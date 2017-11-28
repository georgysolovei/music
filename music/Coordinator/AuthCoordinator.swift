//
//  AuthCoordinator.swift
//  music
//
//  Created by mac-167 on 11/28/17.
//  Copyright © 2017 mac-167. All rights reserved.
//

import UIKit

class AuthCoordinator {
    
    let navigationController : UINavigationController?
    
    init(window: UIWindow) {
        navigationController = window.rootViewController?.navigationController
    }
}

extension AuthCoordinator : CoordinatorProtocol {
    func start() {
        
    }
    
    func finish() {
        
        
    }
    
    
}
