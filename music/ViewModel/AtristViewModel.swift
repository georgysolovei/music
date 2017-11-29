//
//  AtristViewModel.swift
//  music
//
//  Created by mac-167 on 11/27/17.
//  Copyright © 2017 mac-167. All rights reserved.
//

import Foundation

protocol ArtistViewModelProtocol : class {
    var numberOfRows: Int{ get }
    var artists: Dynamic<[Artist]>{ get }
    
    func getArtistForIndex(_ index:Int) -> Artist
    func didScrollToBottom()
    func logOut()
    func didSelectItemAt(_ index:Int)
}

final class AtristViewModel {
    var artists = Dynamic([Artist]())
    var page = 2
    var artistModel = ArtistModel()
    var sessionKey : Dynamic<String?> = Dynamic(nil)
    
    weak var transitionDelegate : TransitionProtocol?
    
    init() {
        sessionKey.value = artistModel.getSessionKey()
        RequestManager.getTopArtists(page: page, success: { response in
            self.artists.value = response
        }, failure: {_ in })
    }
}

extension AtristViewModel : ArtistViewModelProtocol {

    var numberOfRows: Int {
        return artists.value.count
    }
    
    func getArtistForIndex(_ index:Int) -> Artist {
        return artists.value[index]
    }
    
    func didScrollToBottom() {
        RequestManager.getTopArtists(page: page, success: { response in            
            self.artists.value.append(contentsOf: response)
            self.page += 1
        }, failure: { error in })
    }
    
    func logOut() {
        artistModel.deleteSessionKey()
        sessionKey.value = nil
    }
    
    func didSelectItemAt(_ index:Int) {
        let selectedArtist = artists.value[index]
        transitionDelegate?.transitionToArtist(selectedArtist)
    }
}
