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
    public func getArtistsFor(page:Int) -> [Artist]? {
        let realm = try! Realm()
        
        guard let artists = realm.object(ofType: ArtistRealmArray.self, forPrimaryKey: page)  else { return nil }
        
        return Array(artists.artists)
    }
    
    public func cacheArtistsFor(page:Int, artists:[Artist]) -> [Int]? {
        let realm = try! Realm()
        
        let artistRealmArray = ArtistRealmArray(artists: artists, page: page)
        
        try! realm.write {
            realm.add(artistRealmArray)
        }
        return getIndexesOfReplacedArtists(artists)
    }
    
    // MARK: - Private
    private func getIndexesOfReplacedArtists(_ artists:[Artist]) -> [Int]? {
        let realm = try! Realm()

        let artistRealmArrays = realm.objects(ArtistRealmArray.self)
        let artists = Array(artistRealmArrays.flatMap({ $0.artists }))
        
        var indexes: [Int]?
            
        for item in artists {
            if artists.contains(item) {
                guard let index = artists.index(of: item) else { continue }
                if indexes == nil {
                    indexes = [Int]()
                    indexes?.append(index)
                } else {
                    indexes?.append(index)
                }
            }
        }
        return indexes
    }
    
    private func clearCacheIfNeeded() {
        
    }
}
