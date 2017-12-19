//
//  ArtistRealmArray.swift
//  music
//
//  Created by mac-167 on 12/19/17.
//  Copyright © 2017 mac-167. All rights reserved.
//

import RealmSwift

class ArtistRealmArray: RootObject {
    var artists = List<Artist>()
    convenience init(artists:[Artist], page:Int) {
        self.init()
        id = page
        self.artists.append(objectsIn: artists)
    }
}
