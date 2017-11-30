//
//  SongViewModel.swift
//  music
//
//  Created by mac-167 on 11/29/17.
//  Copyright © 2017 mac-167. All rights reserved.
//

protocol TrackListViewModelProtocol : class {
    var tracksCount: Int { get }
    func trackAt(index:Int) -> Track?
    func didPressBackButton()
}

class TrackListViewModel  {
    var tracks : Dynamic<[Track]?>
    let artist : Artist
    let page = 1
    
    weak var trackListDelegate: TrackListViewModelDelegate?

    init(artist:Artist) {
        self.artist = artist
        self.tracks = Dynamic(nil)
        RequestManager.getTracksForArtist(artist.name, success: { response in
            self.tracks.value = response
        }, failure: { _ in })
    }
}

extension TrackListViewModel : TrackListViewModelProtocol {
    
    var tracksCount: Int {
        return tracks.value?.count ?? 0
    }

    func trackAt(index:Int) -> Track? {
        guard let track = tracks.value?[index] else { return nil }
        return track
    }
    func didPressBackButton() {
        trackListDelegate?.didPressBackButton()
    }
}
