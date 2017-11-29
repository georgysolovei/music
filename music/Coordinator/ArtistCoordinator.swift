//
//  ArtistCoordinator.swift
//  music
//
//  Created by mac-167 on 11/28/17.
//  Copyright © 2017 mac-167. All rights reserved.
//

import UIKit

protocol TransitionProtocol : class {
    func transitionToArtist(_ artist: Artist)
}

class ArtistCoordinator {
    
    var navigationController : UINavigationController?
    weak var window: UIWindow!
    weak var authDelegate : AuthDelegate!

    init(window: UIWindow) {
        self.window = window
    }
}

extension ArtistCoordinator : CoordinatorProtocol {
    func start() {
        
        navigationController = R.storyboard.artist.instantiateInitialViewController()
        window.rootViewController = navigationController
        let artistController = navigationController?.childViewControllers.first as! ArtistController 
      
        let artistViewModel = AtristViewModel()
        artistViewModel.transitionDelegate = self
        artistController.artistViewModel = artistViewModel

        // ArtistViewModel Binding
        artistViewModel.sessionKey.bind {
            if isNilOrEmpty($0) {
                self.finish()
            }
        }
    }
    
    func finish() {
        authDelegate.logOut()
    }
}

extension ArtistCoordinator : TransitionProtocol {
    
    func transitionToArtist(_ artist: Artist) {
     
        let trackListCoorinator = TrackListCoordinator(window: window, artist:artist)
        trackListCoorinator.start()
    }
}
