//
//  SongViewModel.swift
//  music
//
//  Created by mac-167 on 11/29/17.
//  Copyright © 2017 mac-167. All rights reserved.
//

protocol TrackListViewModelProtocol : class {
    var tracksCount: Int { get }
}

class TrackListViewModel  {
    var tracks : [Track]?
    let artist : Artist
    init(artist:Artist) {
        self.artist = artist
    }
}
extension TrackListViewModel : TrackListViewModelProtocol {
    var tracksCount: Int {
        return tracks?.count ?? 0
    }
}
