//
//  CellModel.swift
//  music
//
//  Created by mac-167 on 12/26/17.
//  Copyright © 2017 mac-167. All rights reserved.
//

import RealmSwift

class ArtistCellModel {
    func getArtistFor(_ index:Int) -> Artist? {
        let realm = try! Realm()
        let realmArtists = realm.objects(Artist.self)
        let artist = realmArtists.filter{ realmArtists.index(of: $0) == index }.first
        
        return artist
    }
}
