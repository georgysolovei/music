//
//  ArtistModel.swift
//  music
//
//  Created by mac-167 on 11/27/17.
//  Copyright © 2017 mac-167. All rights reserved.
//

import RxSwift
import RealmSwift

final class ArtistModel {
    
    var displayArtists: Results<DisplayArtists> {
        let realm = try! Realm()
        
        if realm.objects(DisplayArtists.self).first == nil {
            let displayArtists = DisplayArtists()
            try! realm.write {
                realm.add(displayArtists)
            }
        }
        return realm.objects(DisplayArtists.self)
    }
    
    func cachedArtistsFor(_ page:Int) -> List<Artist>? {
        return PersistencyManager.shared.getArtistsFor(page)
    }
    
    func deleteSessionKey() {
        PersistencyManager.shared.deleteSessionKey()
    }
    
    func getSessionKey() -> String? {
        return PersistencyManager.shared.getSessionKey()
    }
    
    func cacheArtistsFor(page:Int, artists:[Artist]) -> [Int]? {
       return PersistencyManager.shared.cacheArtistsFor(page: page, artists:artists)
    }
    
    func saveToDisplayArtists(_ fetchedArtists:List<Artist>, isReplace:Bool = false) {
        let realm = try! Realm()

        try! realm.write {
            if isReplace == true {
                 realm.objects(DisplayArtists.self).first?.artists.removeAll()
            }
            realm.objects(DisplayArtists.self).first?.artists.append(objectsIn: fetchedArtists)
        }
    }
    
    func clearDisplayArtists() {
        let realm = try! Realm()
        try! realm.write {
            realm.objects(DisplayArtists.self).first?.artists.removeAll()
        }
    }
    
}
