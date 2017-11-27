//
//  AppCordinator.swift
//  music
//
//  Created by mac-167 on 11/27/17.
//  Copyright © 2017 mac-167. All rights reserved.
//

import UIKit

final class Coordinator {
    weak var navigationController: UINavigationController?
    
    private struct Const {
        static let artistController = "ArtistController"
        static let loginController = "LogInController"
        static let main = "Main"
    }
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let storyboard = UIStoryboard(name: Const.main, bundle: nil)
        var viewController: UIViewController!

        if let _ = PersistencyManager.shared.getSessionKey() {
            viewController = storyboard.instantiateViewController(withIdentifier: Const.artistController)

        } else {
            let loginViewModel = LogInViewModel()
            viewController = storyboard.instantiateViewController(withIdentifier: Const.loginController)
            (viewController as! LogInController).viewModel = loginViewModel
          
            loginViewModel.sessionKey.bind {
                if $0.isEmpty {
                    self.navigationController?.popViewController(animated: true)
                } else {
                    viewController = storyboard.instantiateViewController(withIdentifier: Const.artistController)
                    self.navigationController?.pushViewController(viewController, animated: false)
                }
            }
        }
        navigationController?.pushViewController(viewController, animated: false)
    }
}
