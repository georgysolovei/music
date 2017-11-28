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
            child = AuthCoordinator(window:window)
            (child as! AuthCoordinator).sessionKey.bind {
                if !isNilOrEmpty($0) {
                    self.start()
                }
            }
        } else {
            child = ArtistCoordinator(window:window)
            (child as! ArtistCoordinator).sessionKey.bind {
                if isNilOrEmpty($0) {
                    self.start()
                }
            }
        }
        child!.start()
    }
}
