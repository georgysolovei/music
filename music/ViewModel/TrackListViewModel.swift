//
//  SongViewModel.swift
//  music
//
//  Created by mac-167 on 11/29/17.
//  Copyright © 2017 mac-167. All rights reserved.
//

import RxSwift

protocol TrackListViewModelProtocol : class {
    var tracksCount: Int { get }
    func trackAt(index:Int) -> Track?
    func didPressBackButton()
}

class TrackListViewModel  {
    var tracks : Variable<[Track]?>
    let artist : Artist
    let page = 1
    var disposeBag = DisposeBag()

    weak var trackListDelegate: TrackListViewModelDelegate?

    init(artist:Artist) {
        self.artist = artist
        self.tracks = Variable(nil)
        
        RequestManager.getTracksForArtist(artist.name).subscribe({ event in
            if let tracks = event.element {
                if !isNilOrEmpty(tracks) {
                    self.tracks.value = tracks!
                }
            }
        }).disposed(by: disposeBag)
    }
}

extension TrackListViewModel : TrackListViewModelProtocol {
    
    var tracksCount: Int {
        return tracks.value?.count ?? 0
    }

    func trackAt(index:Int) -> Track? {
        guard let tracks = tracks.value else { return Track() }
        let track = tracks[index]
        return track
    }
    
    func didPressBackButton() {
        trackListDelegate?.didPressBackButton()
    }
}
