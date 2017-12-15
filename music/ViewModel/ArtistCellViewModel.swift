//
//  ArtistCellViewModel.swift
//  music
//
//  Created by mac-167 on 12/15/17.
//  Copyright © 2017 mac-167. All rights reserved.
//

class ArtistCellViewModel {
    
    var artistName: String? {
       return artist.name
    }
    var listenersCount: String? {
        return artist.listeners
    }
    var link: String? {
        return artist.imageUrl
    }
    
    private var artist: Artist
    
    init(_ artist:Artist) {
        self.artist = artist
    }
}
