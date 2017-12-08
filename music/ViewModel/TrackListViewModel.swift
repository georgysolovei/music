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
    var isLoading: Variable<Bool> { get }
    func trackAt(index:Int) -> Track?
    func didPressBackButton()
    var errorMessage : Variable<String?> { get }
    var artistName: String { set get }
}

class TrackListViewModel  {
    var tracks : Variable<[Track]?>
    let artist : Artist
    let page = 1
    var disposeBag = DisposeBag()
    var isFinished = Variable(false)
    var errorMessage : Variable<String?> = Variable(nil)
    var artistName: String

    let isLoading = Variable(false)

    weak var trackListDelegate: TrackListViewModelDelegate?

    init(artist:Artist) {
        self.artist = artist
        tracks = Variable(nil)
        isLoading.value = true
        artistName = artist.name
        RequestManager.getTracksForArtist(artist.name).subscribe(onNext: {
                if !isNilOrEmpty($0) {
                    self.tracks.value = $0
                }
                self.isLoading.value = false
            
            }, onError: { error in
                print(error.localizedDescription)
                self.errorMessage.value = String(describing: error)
                self.isLoading.value = false
                
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
