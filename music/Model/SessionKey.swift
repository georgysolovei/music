//
//  RealmString.swift
//  music
//
//  Created by mac-167 on 11/20/17.
//  Copyright © 2017 mac-167. All rights reserved.
//
import RealmSwift
class SessionKey : Object {
    @objc dynamic var key = ""
    
    convenience init(_ key:String) {
        self.init()
        self.key = key
    }
}
