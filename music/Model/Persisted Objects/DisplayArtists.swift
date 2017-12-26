//
//  DisplayArtists.swift
//  music
//
//  Created by mac-167 on 12/26/17.
//  Copyright © 2017 mac-167. All rights reserved.
//

import RealmSwift

class DisplayArtists : Object {
    var artists = List<Artist>()
}
