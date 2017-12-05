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
    var artists: Variable<[Artist]?>{ get }

    func getArtistForIndex(_ index:Int) -> Artist
    func didScrollToBottom()
    func logOut()
    func didSelectItemAt(_ index:Int)
}

final class AtristViewModel {
    var artists : Variable<[Artist]?>
    var page = 2
    var artistModel = ArtistModel()
    var isFinished = Variable(false)
    
    var disposeBag = DisposeBag()
    weak var transitionDelegate : TransitionProtocol?
    
    init() {
        artists = Variable(nil)
        
        RequestManager.getTopArtists(page: page).subscribe(onNext: {
            self.artists.value = $0
        }).disposed(by: disposeBag)
    }
}

extension AtristViewModel : ArtistViewModelProtocol {

    var numberOfRows: Int {
        return artists.value?.count ?? 0
    }
    
    func getArtistForIndex(_ index:Int) -> Artist {
        guard let artists = artists.value else { return Artist() }
        let artist = artists[index]
        return artist
    }
    
    func didScrollToBottom() {

        RequestManager.getTopArtists(page: page).subscribe(onNext: {
            if let appendArtists = $0 {
                self.artists.value?.append(contentsOf: appendArtists)
                self.page += 1
            }
        }).disposed(by: disposeBag)
    }
    
    func logOut() {
        artistModel.deleteSessionKey()
        isFinished.value = true
    }
    
    func didSelectItemAt(_ index:Int) {
        guard let artists = artists.value else { return }
         let selectedArtist = artists[index]
        transitionDelegate?.transitionToArtist(selectedArtist)
    }
}
