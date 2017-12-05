//
//  AuthCoordinator.swift
//  music
//
//  Created by mac-167 on 11/28/17.
//  Copyright © 2017 mac-167. All rights reserved.
//

import UIKit
import RxSwift

protocol AuthDelegate : class {
    func logIn()
    func logOut()
}

class AuthCoordinator {
    
    var navigationController : UINavigationController?
    weak var window: UIWindow!
    let disposeBag = DisposeBag()

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
        
        loginViewModel.sessionKey.asObservable().subscribe(onNext: { event in
            if !isNilOrEmpty(event) {
                print(event!)
                self.finish()
            }
        }).disposed(by: disposeBag)
    }
    
    func finish() {
        authDelegate.logIn()
    }
}


