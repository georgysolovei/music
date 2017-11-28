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
}

final class RootCoordinator : CoordinatorProtocol {
    weak var window: UIWindow!
    
    private struct Const {
        static let artistController = "ArtistController"
        static let loginController = "LogInController"
        static let main = "Main"
    }
    
    var authCoordinator : AuthCoordinator!
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
 
        let sessionKey = PersistencyManager.shared.getSessionKey()
        
        if isNilOrEmpty(sessionKey) {
            // TODO: create authCoordinator
            authCoordinator = AuthCoordinator(window:window)
            authCoordinator.start()
            
            // TODO: move to authCoordinator
//            let loginViewController = R.storyboard.main.logInController()
//            loginViewController?.viewModel = LogInViewModel()
        } else {
            // TODO: create mainCoordinator
            // mainCoordinator.start(window)
            
            // TODO: move to mainCoordinator
//            let artistViewController = R.storyboard.main.artistController()
//            artistViewController?.artistViewModel = ArtistViewModel()
        }
        

//        // First Load
//        if navigationController?.viewControllers.first is LogInController {
//            viewController = navigationController?.viewControllers.first
//        } else {
//            viewController = R.storyboard.main.logInController()
//            navigationController?.pushViewController(viewController, animated: true)
//        }
//        (viewController as! LogInController).viewModel = loginViewModel
//
//        // LogInViewModel Binding
//        loginViewModel.sessionKey.bind {
//            if isNilOrEmpty($0) {
//                self.navigationController?.popViewController(animated: true)
//            } else {
//             //   viewController = storyboard.instantiateViewController(withIdentifier: Const.artistController)
//                (viewController as! ArtistController).artistViewModel = artistViewModel
//                self.navigationController?.pushViewController(viewController, animated: true)
//            }
//        }
//
//        // ArtistViewModel Binding
//        artistViewModel.sessionKey.bind {
//            if isNilOrEmpty($0) {
//                self.navigationController?.popViewController(animated: true)
//            }
//        }
    }
    
    func finish() {
        
    }
}
