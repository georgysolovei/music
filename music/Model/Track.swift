//
//  Song.swift
//  music
//
//  Created by mac-167 on 11/29/17.
//  Copyright © 2017 mac-167. All rights reserved.
//

import RealmSwift

class Track: Object {
    @objc dynamic var name = ""
    @objc dynamic var playcount = 0
    @objc dynamic var listeners = 0
    @objc dynamic var imageUrl = ""
    @objc dynamic var rank = 0
}
