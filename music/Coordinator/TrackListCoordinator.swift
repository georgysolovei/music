//
//  SongCoordinator.swift
//  music
//
//  Created by mac-167 on 11/29/17.
//  Copyright © 2017 mac-167. All rights reserved.
//

import UIKit

class TrackListCoordinator : Coordinator {
    
    var artist : Artist
    
    init(window:UIWindow, artist: Artist) {
        self.artist = artist
        super.init(window: window)
    }
    
    override func start() {
        let trackListController = R.storyboard.artist.trackListController()
        let trackListViewModel  = TrackListViewModel(artist:artist)
        trackListController?.viewModel = trackListViewModel
        
        window.rootViewController = trackListController
    }
}
