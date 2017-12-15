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
//    var artists:      Variable<[Artist]?> { get }
    var newIndexPaths: Variable<[IndexPath]?> { get }

    var isLoading:    Variable<Bool>      { get }
    var isRefreshing: Variable<Bool>      { get }
    var isFinished:   Variable<Bool>      { get }
    var errorMessage: Variable<String?>   { get }
    var logOutTapped: PublishSubject<Void>{ get }
    var linkTapped:   PublishSubject<Void>{ get }

    func getArtistCellViewModelFor(_ index:Int) -> ArtistCellViewModel
    func didScrollToBottom()
    func didSelectItemAt(_ index:Int)
    func loadArtists()
}

final class AtristViewModel {
    var artists      : Variable<[Artist]?>
    var newIndexPaths: Variable<[IndexPath]?>
    let isLoading    = Variable(false)
    var errorMessage : Variable<String?> = Variable(nil)
    var logOutTapped = PublishSubject<Void>()
    var linkTapped   = PublishSubject<Void>()
    var isFinished   = Variable(false)
    let isRefreshing = Variable<Bool>(false)

    var disposeBag = DisposeBag()
    weak var transitionDelegate : TransitionProtocol?
    private var page = 2
    var artistModel = ArtistModel()
    
    init() {
        artists = Variable(nil)
        newIndexPaths = Variable(nil)
        
        isLoading.value = true
        loadArtists()
        logOutTapped
            .asObservable()
            .subscribe(onNext:{
                self.logOut()
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

        return artistCellViewModel
    }
    
    func didScrollToBottom() {

        RequestManager.getTopArtists(page: page)
            .subscribe(onNext: {
                self.artists.value?.append(contentsOf: $0)
                self.newIndexPaths.value = self.getNewRowsFor($0)
                self.page += 1
                self.isLoading.value = false
            }, onError:{ error in
                print(error)
                self.errorMessage.value = String(describing: error)
                self.isLoading.value = false
                if self.isRefreshing.value == true {
                    self.isRefreshing.value = false
                }
            }, onCompleted: {
                self.isLoading.value = false
            }).disposed(by: disposeBag)
    }
    
    private func logOut() {
        artistModel.deleteSessionKey()
        isFinished.value = true
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
        
        RequestManager.getTopArtists(page: page)
            .subscribe(onNext: {
                self.artists.value = $0
                self.newIndexPaths.value = self.getNewRowsFor($0)
                
                if self.isLoading.value == true {
                    self.isLoading.value = false
                } else {
                    self.isRefreshing.value = false
                }
                
            }, onError:{ error in
                self.errorMessage.value = String(describing: error)
                print(error.localizedDescription)
                self.isLoading.value = false
                
            }).disposed(by: disposeBag)
    }
}
