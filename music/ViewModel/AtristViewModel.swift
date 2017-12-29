//
//  AtristViewModel.swift
//  music
//
//  Created by mac-167 on 11/27/17.
//  Copyright © 2017 mac-167. All rights reserved.
//

import RxSwift
import RealmSwift
import UIKit

protocol ArtistViewModelProtocol : class {
    var numberOfRows: Int{ get }
    var isLoading:    Variable<Bool>      { get }
    var isRefreshing: Variable<Bool>      { get }
    var isFinished:   Variable<Bool>      { get }
    var errorMessage: Variable<String?>   { get }
    var logOutTapped: PublishSubject<Void>{ get }
    var realmChanges: Variable<([IndexPath], [IndexPath], [IndexPath])?> { get }
    
    func getArtistCellViewModelFor(_ index:Int) -> ArtistCellViewModel
    func didSelectItemAt(_ index:Int)
    func refresh()
    func loadMore()
}

final class AtristViewModel {
    let isLoading    = Variable(false)
    var errorMessage:  Variable<String?> = Variable(nil)
    var logOutTapped = PublishSubject<Void>()
    var isFinished   = Variable(false)
    let isRefreshing = Variable<Bool>(false)
    var page         = Variable(Const.defaultPage)
    var realmChanges:  Variable<([IndexPath], [IndexPath], [IndexPath])?> = Variable(nil)
    
    var link : Variable<String?> = Variable(nil)
   
    var displayArtists : List<Artist> {
        return artistModel.displayArtists.first!.artists
    }

    var disposeBag = DisposeBag()
    weak var transitionDelegate : TransitionProtocol?
    var artistModel = ArtistModel()
    var notificationToken : NotificationToken?

    private struct Const {
        static let defaultPage = 2
    }
    
    init() {
        
        artistModel.clearDisplayArtists()
        
        page.asObservable()
            .observeOn(backgroundScheduler)
            .skipWhile {_ in
                return !self.displayArtists.isEmpty
            }
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
        
        notificationToken = displayArtists.observe { change in
            switch change {
            case .initial:
                print("subsribed")
            case .update(_, let deletions, let insertions, let modifications):
                print(".update")
                self.realmChanges.value = (insertions.map({ IndexPath(row: $0, section: 0) }),
                                            deletions.map({ IndexPath(row: $0, section: 0) }),
                                        modifications.map({ IndexPath(row: $0, section: 0) }))
            case .error(let error):
                fatalError("\(error)")
            }
        }
    }
    
    func getNewRowsFor(_ newArtists:[Artist]) -> [IndexPath] {
        
        let newIndexPaths = newArtists.map{ artist -> IndexPath in
            guard let indexOfNewArtist = displayArtists.index(of: artist) else { return IndexPath(row:0, section:0) }
            let indexPath = IndexPath.init(row: indexOfNewArtist, section: 0)
            return indexPath
        }
        return newIndexPaths
    }
}

extension AtristViewModel : ArtistViewModelProtocol {
    
    var numberOfRows: Int {
        return displayArtists.count
    }
    
    func getArtistCellViewModelFor(_ index:Int) -> ArtistCellViewModel {
        let artist = displayArtists[index]
        let artistCellViewModel = ArtistCellViewModel(artist, cellNumber: index)
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
        let selectedArtist = displayArtists[index]
        transitionDelegate?.transitionToArtist(selectedArtist)
    }
    
    private func loadArtists() {
        
        // DataBase request
        //--------------------------------------------------
        let isReplace = self.page.value == Const.defaultPage
        if let retrievedArtists = self.artistModel.cachedArtistsFor(self.page.value) {
            self.artistModel.saveToDisplayArtists(retrievedArtists, isReplace:isReplace)
        } else {
            isLoading.value = true
        }
        
        print("Request for PAGE:", page.value)
        
        // Network request
        //--------------------------------------------------
        RequestManager.getTopArtists(page: page.value)
            .observeOn(backgroundScheduler)
            .subscribe(onNext: {
                print($0.count)
                
                let retrievedArtists = self.artistModel.cachedArtistsFor(self.page.value)
                let indexesToReplace = self.artistModel.cacheArtistsFor(page: self.page.value, artists: $0)

                if retrievedArtists == nil || !isNilOrEmpty(indexesToReplace) {
                    if let retrievedArtists = self.artistModel.cachedArtistsFor(self.page.value) {
                        self.artistModel.saveToDisplayArtists(retrievedArtists, isReplace:isReplace)
                    }
                }
  
                self.isLoading.value = false
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
