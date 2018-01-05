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
        
        let realm = try! Realm()
        guard let artistRealmArray = realm.object(ofType: ArtistRealmArray.self, forPrimaryKey: page) else { return nil }
        
        return artistRealmArray.artists
    }
    
    func deleteSessionKey() {
        let realm = try! Realm()
        
        let sessionKeyObjects = realm.objects(SessionKey.self)
        try! realm.write {
            realm.delete(sessionKeyObjects)
        }
    }
    
    func getSessionKey() -> String? {
        let realm = try! Realm()
        
        if let sessionKey = realm.objects(SessionKey.self).first?.key {
            return sessionKey
        } else {
            return nil
        }
    }
    
    func cacheArtistsFor(page:Int, artists:[Artist]) -> [Int]? {   // returns indexes to reload table
        
        let realm = try! Realm()
        
        let retrievedArtists = getArtistsFor(page)
        
        if retrievedArtists == nil {
            let artistRealmArray = ArtistRealmArray(artists: artists, page: page)
            try! realm.write {
                realm.add(artistRealmArray)
            }
        } else {
            
            let indexesOfReplacedArtists = compareArtists(artistsFromRealm: retrievedArtists!, artistsFromWeb: artists)
            
            if !isNilOrEmpty(indexesOfReplacedArtists) {
                replaceOldArtistsWith(artists, at: page)
            }
            return indexesOfReplacedArtists.isEmpty ? nil : indexesOfReplacedArtists
        }
        return nil
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
    
    public func getArtistsFor(_ page:Int) -> List<Artist>? {
        let realm = try! Realm()
        guard let artists = realm.object(ofType: ArtistRealmArray.self, forPrimaryKey: page) else { return nil }
        
        return artists.artists
    }
    
    // Private
    private func compareArtists(artistsFromRealm:List<Artist>, artistsFromWeb:[Artist]) -> [Int] {
        
        let realm = try! Realm()
        let artistRealmArrays = realm.objects(ArtistRealmArray.self)
        // let artists = Array(artistRealmArrays.flatMap({ $0.artists }))
        let artists = List<Artist>()
        artists.append(objectsIn: Array(artistRealmArrays.flatMap({ $0.artists })))
        
        var indexes = [Int]()
        
        for realmArtist in artistsFromRealm {
            guard let indexInRealmArtists = artistsFromRealm.index(of: realmArtist) else { return [Int]() }
            let webArtist = artistsFromWeb[indexInRealmArtists]
            if !(realmArtist == webArtist) {
                let generalIndex = artists.index(of: realmArtist)
                indexes.append(generalIndex!)
            }
        }
        
        // TEST
        //        try! realm.write {
        //            artists[0].name = "TEST"
        //        }
        
        print("INDEXES TO REPLACE:", indexes)
        return indexes
    }
    
    private func replaceOldArtistsWith(_ newArtists:[Artist], at page:Int) {
        let realm = try! Realm()
        guard let artistsRealmArray = realm.object(ofType: ArtistRealmArray.self, forPrimaryKey: page) else { return }
        let newRealmArtists = List<Artist>()
        newRealmArtists.append(objectsIn:newArtists)
        
        try! realm.write {
            artistsRealmArray.setValue(newRealmArtists, forKey: "artists")
        }
    }
}
