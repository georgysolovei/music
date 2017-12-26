//
//  PersistencyManager.swift
//  music
//
//  Created by mac-167 on 11/20/17.
//  Copyright © 2017 mac-167. All rights reserved.
//

import RealmSwift

final class PersistencyManager {

    static let shared = PersistencyManager()

    // MARK: - Session Key
    public func saveSessionKey(_ key:String) {
        let realm = try! Realm()

        try! realm.write {
            let sessionKey = SessionKey(key)
            realm.add(sessionKey)
        }
    }
    
    public func getSessionKey() -> String? {
        let realm = try! Realm()

        if let sessionKey = realm.objects(SessionKey.self).first?.key {
            return sessionKey
        } else {
            return nil
        }
    }
    
    public func deleteSessionKey() {
        let realm = try! Realm()

        let sessionKeyObjects = realm.objects(SessionKey.self)
        try! realm.write {
            realm.delete(sessionKeyObjects)
        }
    }
    
    // MARK: - Artists
    public func getArtistsFor(_ page:Int) -> [Artist]? {
        let realm = try! Realm()
        guard let artists = realm.object(ofType: ArtistRealmArray.self, forPrimaryKey: page) else { return nil }
        
        return Array(artists.artists)
    }
    
    public func cacheArtistsFor(page:Int, artists:[Artist]) -> [Int]? { // return indexes to reload
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
    
    public func getArtistFor(_ index:Int) -> Artist? {
        let realm = try! Realm()
        let realmArtists = realm.objects(Artist.self)
        let artist = realmArtists.filter{ realmArtists.index(of: $0) == index }.first
        
        return artist
    }
    
    public func getDisplayArtists() -> Results<DisplayArtists> {
        let realm = try! Realm()

        if realm.objects(DisplayArtists.self).first == nil {
            let displayArtists = DisplayArtists()
            try! realm.write {
                realm.add(displayArtists)
            }
        }
        return realm.objects(DisplayArtists.self)
    }
    
    public func clearDisplayArtists() {
        let realm = try! Realm()
         try! realm.write {
            realm.delete(realm.objects(DisplayArtists.self))
        }
    }
    
    // MARK: - Private
    private func compareArtists(artistsFromRealm:[Artist], artistsFromWeb:[Artist]) -> [Int] {
        
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
        
 //       print("INDEXES TO BE REPLACED:", indexes)
        return indexes
    }
    
    private func replaceOldArtistsWith(_ newArtists:[Artist], at page:Int) {
        let realm = try! Realm()
        guard let artistsRealmArray = realm.object(ofType: ArtistRealmArray.self, forPrimaryKey: page) else { return }
        let newRealmArtists = List<Artist>()
        newRealmArtists.append(objectsIn:newArtists)
        
        try! realm.write {
     //       artistsRealmArray.artists = List<Artist>()
            artistsRealmArray.setValue(newRealmArtists, forKey: "artists")
        }
    }

    private func clearCacheIfNeeded() {
        
    }
}
