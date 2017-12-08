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
    var isLoading: Variable<Bool> { get }
    var isRefreshing: Variable<Bool> { get }

    var errorMessage : Variable<String?> { get }

    func getArtistForIndex(_ index:Int) -> Artist
    func didScrollToBottom()
    func logOut()
    func didSelectItemAt(_ index:Int)
    func loadArtists()
}

final class AtristViewModel {
    var artists : Variable<[Artist]?>
    var page = 2
    var artistModel = ArtistModel()
    var isFinished = Variable(false)
    var errorMessage : Variable<String?> = Variable(nil)

    var disposeBag = DisposeBag()
    weak var transitionDelegate : TransitionProtocol?
    
    let isLoading = Variable(false)
    let isRefreshing = Variable<Bool>(false)

    init() {
        artists = Variable(nil)
        isLoading.value = true

        loadArtists()
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
            self.artists.value?.append(contentsOf: $0)
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
    
    func logOut() {
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
        
        RequestManager.getTopArtists(page: page).subscribe(onNext: {
            self.artists.value = $0
            
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
