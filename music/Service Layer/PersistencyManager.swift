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
    let realm = try! Realm()

    public func saveSessionKey(_ key:String) {
        try! realm.write {
            let sessionKey = SessionKey(key)
            realm.add(sessionKey)
        }
    }
    
    public func getSessionKey() -> String? {
        if let sessionKey = realm.objects(SessionKey.self).first?.key {
            return sessionKey
        } else {
            return nil
        }
    }
    
    public func deleteSessionKey() {
        let sessionKeyObjects = realm.objects(SessionKey.self)
        try! realm.write {
            realm.delete(sessionKeyObjects)
        }
    }
}
