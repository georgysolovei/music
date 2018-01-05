//
//  LoginModel.swift
//  music
//
//  Created by mac-167 on 11/27/17.
//  Copyright © 2017 mac-167. All rights reserved.
//

import RealmSwift

final class LogInModel {
    func saveSessionKey(_ key:String) {
            let realm = try! Realm()
            
            try! realm.write {
                let sessionKey = SessionKey(key)
                realm.add(sessionKey)
            }
    }
}
