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
    func getArtistForIndex(_ index:Int) -> Artist
    func didScrollToBottom()
    func logOut()
}

final class AtristViewModel {
    var artists = Dynamic([Artist]())
    var page = 2
    var artistModel = ArtistModel()
    var sessionKey : Dynamic<String?> {
        didSet {
            if isNilOrEmpty(sessionKey.value) {
                artistModel.deleteSessionKey()
            }
        }
    }
    
    init() {
        sessionKey = Dynamic(nil)
        sessionKey.value = artistModel.getSessionKey()
    }
}

extension AtristViewModel : ArtistViewModelProtocol {

    var numberOfRows: Int {
        return artists.value.count
    }
    
//    RequestManager.getTopArtists(page: page, success: { response in
//    self.artists.removeAll()
//    self.artists = response
//
//    self.tableView.reloadData()
//    self.tableView.isHidden = self.artists.isEmpty ? true : false
//    self.page += 1
//
//    }, failure: { error in })
//}
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
        sessionKey.value = ""
    }
}
