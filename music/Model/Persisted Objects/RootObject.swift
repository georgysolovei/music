//
//  RootObject.swift
//  music
//
//  Created by mac-167 on 12/19/17.
//  Copyright © 2017 mac-167. All rights reserved.
//

import RealmSwift

class RootObject : Object {
    
    @objc dynamic var id  = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
