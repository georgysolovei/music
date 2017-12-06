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
}

class TrackListViewModel  {
    var tracks : Variable<[Track]?>
    let artist : Artist
    let page = 1
    var disposeBag = DisposeBag()
    var isFinished = Variable(false)

    let isLoading = Variable(false)

    weak var trackListDelegate: TrackListViewModelDelegate?

    init(artist:Artist) {
        self.artist = artist
        self.tracks = Variable(nil)
        isLoading.value = true

        RequestManager.getTracksForArtist(artist.name).subscribe(onNext: {
                if !isNilOrEmpty($0) {
                    self.tracks.value = $0
                }
                self.isLoading.value = false
            
            }, onError: { error in
                AlertManager.showAlert(title: "Error", message: "Loading failed")
                print(error.localizedDescription)
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
