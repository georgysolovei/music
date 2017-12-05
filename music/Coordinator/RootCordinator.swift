//
//  AppCordinator.swift
//  music
//
//  Created by mac-167 on 11/27/17.
//  Copyright © 2017 mac-167. All rights reserved.
//

import UIKit

protocol CoordinatorProtocol {
    func start()
    func finish()
}

protocol RootCoordinatorProtocol {
    func start()
}

final class RootCoordinator : RootCoordinatorProtocol {

    weak var window: UIWindow!

    var child: CoordinatorProtocol?
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        
        let sessionKey = PersistencyManager.shared.getSessionKey()
        
        if isNilOrEmpty(sessionKey) {
            showAuthScreen()
        } else {
           showArtistScreen()
        }
    }
    
    func showAuthScreen() {
        child = AuthCoordinator(window:window)
        (child as! AuthCoordinator).authDelegate = self
        child!.start()
    }
    
    func showArtistScreen() {
        child = ArtistCoordinator(window:window)
        (child as! ArtistCoordinator).authDelegate = self
        child!.start()
    }
}

extension RootCoordinator : AuthDelegate {
    func logIn() {
        showArtistScreen()
    }
    
    func logOut() {
        showAuthScreen()
    }
}
