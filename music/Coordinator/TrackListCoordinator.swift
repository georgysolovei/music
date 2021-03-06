//
//  SongCoordinator.swift
//  music
//
//  Created by mac-167 on 11/29/17.
//  Copyright © 2017 mac-167. All rights reserved.
//

import UIKit

protocol TrackListViewModelDelegate : class {
    func didPressBackButton()
}

class TrackListCoordinator  {
    
    var artist : Artist
    var navigationController : UINavigationController?

    weak var trackListDelegate : TrackListCoordinatorDelegate?
    weak var window: UIWindow!

    init(window:UIWindow, artist: Artist) {
        self.window = window
        self.artist = artist
    }
    
    func start() {
        let trackListController = R.storyboard.artist.trackListController()
        let trackListViewModel  = TrackListViewModel(artist:artist)
       
        trackListController?.viewModel = trackListViewModel
        trackListViewModel.trackListDelegate = self
        
        navigationController = window.rootViewController as? UINavigationController

        navigationController?.pushViewController(trackListController!, animated: true)
    }
}

extension TrackListCoordinator : TrackListViewModelDelegate {
    func didPressBackButton() {
        trackListDelegate?.didFinishTrackList()
    }
}
