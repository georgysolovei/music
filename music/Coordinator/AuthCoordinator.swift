//
//  AuthCoordinator.swift
//  music
//
//  Created by mac-167 on 11/28/17.
//  Copyright © 2017 mac-167. All rights reserved.
//

import UIKit

protocol AuthDelegate : class {
    func logIn()
    func logOut()
}

class AuthCoordinator {
    
    var navigationController : UINavigationController?
    weak var window: UIWindow!
    
    weak var authDelegate : AuthDelegate!
    
    init(window: UIWindow) {
        self.window = window
    }
}

extension AuthCoordinator : CoordinatorProtocol {
    func start() {

        navigationController = R.storyboard.logIn.instantiateInitialViewController()
        window.rootViewController = navigationController
        let loginController = navigationController?.childViewControllers.first as! LogInController
        
        let loginViewModel = LogInViewModel()
        loginController.viewModel = loginViewModel
        
        // LogInViewModel Binding
        loginViewModel.sessionKey.bind {
            if !isNilOrEmpty($0) {
                self.finish()
            }
        }
    }
    
    func finish() {
        authDelegate.logIn()
    }
}


