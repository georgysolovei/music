//
//  Artist.swift
//  music
//
//  Created by mac-167 on 11/21/17.
//  Copyright © 2017 mac-167. All rights reserved.
//

import RealmSwift

class Artist: Object {
    @objc dynamic var name      = ""
    @objc dynamic var listeners = ""
    @objc dynamic var url       = ""
    @objc dynamic var imageUrl  = ""
}
