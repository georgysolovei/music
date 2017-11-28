//
//  ArtistCoordinator.swift
//  music
//
//  Created by mac-167 on 11/28/17.
//  Copyright © 2017 mac-167. All rights reserved.
//

import UIKit

class ArtistCoordinator {
    
    var navigationController : UINavigationController?
    weak var window: UIWindow!
    
    var sessionKey = Dynamic<String?>(nil)
    
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
        artistController.artistViewModel = artistViewModel

        // ArtistViewModel Binding
        artistViewModel.sessionKey.bind {
            if isNilOrEmpty($0) {
                self.finish()
                self.sessionKey.value = nil
            }
        }
    }
    
    func finish() {
        print("finish")
    }
}
