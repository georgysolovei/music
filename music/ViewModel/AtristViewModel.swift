//
//  AtristViewModel.swift
//  music
//
//  Created by mac-167 on 11/27/17.
//  Copyright © 2017 mac-167. All rights reserved.
//

import RxSwift

protocol ArtistViewModelProtocol : class {
    var numberOfRows: Int{ get }
    var newIndexPaths: Variable<[IndexPath]?> { get }
    
    var isLoading:    Variable<Bool>      { get }
    var isRefreshing: Variable<Bool>      { get }
    var isFinished:   Variable<Bool>      { get }
    var errorMessage: Variable<String?>   { get }
    var logOutTapped: PublishSubject<Void>{ get }

    func getArtistCellViewModelFor(_ index:Int) -> ArtistCellViewModel
    func didSelectItemAt(_ index:Int)
    func refresh()
    func loadMore()
}

final class AtristViewModel {
    var artists      : Variable<[Artist]?>
    var newIndexPaths: Variable<[IndexPath]?>
    let isLoading    = Variable(false)
    var errorMessage : Variable<String?> = Variable(nil)
    var logOutTapped = PublishSubject<Void>()
    var isFinished   = Variable(false)
    let isRefreshing = Variable<Bool>(false)
    var page         = Variable(Const.defaultPage)

    var link : Variable<String?> = Variable(nil)
    
    var disposeBag = DisposeBag()
    weak var transitionDelegate : TransitionProtocol?
    var artistModel = ArtistModel()
    
    private struct Const {
        static let defaultPage = 2
    }
    
    init() {
        
        artists = Variable(artistModel.cachedArtists)
        
        newIndexPaths = Variable(nil)
        
        isLoading.value = true

        page.asObservable()
            .observeOn(backgroundScheduler)
            .subscribe(onNext: { event in
                self.loadArtists()
            })
            .disposed(by: disposeBag)
        
        logOutTapped
            .asObservable()
            .subscribe(onNext:{
                self.artistModel.deleteSessionKey()
                self.isFinished.value = true
            })
            .disposed(by: disposeBag)
    }
    
    func getNewRowsFor(_ newArtists:[Artist]) -> [IndexPath] {
        
        let newIndexPaths = newArtists.map{ artist -> IndexPath in
            guard let indexOfNewArtist = artists.value?.index(of: artist) else { return IndexPath(row:0, section:0) }
            let indexPath = IndexPath.init(row: indexOfNewArtist, section: 0)
            return indexPath
        }
        return newIndexPaths
    }
}

extension AtristViewModel : ArtistViewModelProtocol {
    
    var numberOfRows: Int {
        return artists.value?.count ?? 0
    }
    
    func getArtistCellViewModelFor(_ index:Int) -> ArtistCellViewModel {
        guard let artists = artists.value else { return ArtistCellViewModel(Artist()) }
        let artist = artists[index]
        let artistCellViewModel = ArtistCellViewModel(artist)
        artistCellViewModel.link
            .asObservable()
            .subscribeOn(MainScheduler.instance)
            .subscribe(onNext: { link in
                self.link.value = link
            })
            .disposed(by: disposeBag)
        return artistCellViewModel
    }
    
    func didSelectItemAt(_ index:Int) {
        guard let artists = artists.value else { return }
        let selectedArtist = artists[index]
        transitionDelegate?.transitionToArtist(selectedArtist)
    }
    
    func loadArtists() {
        if isLoading.value == false {
            isRefreshing.value = true
        }
        
        RequestManager.getTopArtists(page: page.value)
            .subscribe(onNext: {
                
                let fetchedArtists = $0
                
                    if self.page.value == Const.defaultPage {
                        self.artists.value = fetchedArtists
                    } else {
                        self.artists.value?.append(contentsOf: fetchedArtists)
                    }

                self.newIndexPaths.value = self.getNewRowsFor(self.artists.value!)

                self.artistModel.cacheArtistsFor(page: self.page.value, artists: fetchedArtists)

                if self.isLoading.value == true {
                    self.isLoading.value = false
                }
//                else {
//                    self.isRefreshing.value = false
//                }
                
            }, onError:{ error in
                self.errorMessage.value = String(describing: error)
                print(error.localizedDescription)
                self.isLoading.value = false
                
            }).disposed(by: disposeBag)
    }
    
    func refresh() {
        isRefreshing.value = true
        page.value = Const.defaultPage
    }
    
    func loadMore() {
        page.value += 1
    }
}
