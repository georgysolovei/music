//
//  Coordinator.swift
//  music
//
//  Created by mac-167 on 11/29/17.
//  Copyright © 2017 mac-167. All rights reserved.
//

import UIKit

class Coordinator : NSObject {
    
    // RootViewController for the Coordinator. This ViewController is injected into the Coordinator during the initialization and the Coordinator knows how to use it to display the ViewController it is in charge of.
 //   let rootViewController: UIViewController
    
    let window: UIWindow
    
    // List of Child Coordinators. Here is where all the references are stored for all Child Coordinators, so they are not deallocated before they need to be. The Parent Coordinator is in charge of deallocating all the Child Coordinators when the time is right.
    private(set) var childCoordinators: [Coordinator]
    
    // Block which the coordinator must call when it’s done its job. The Parent Coordinator usually deallocates the Child coordinator in this block.
    var onEnding: (() -> Void)?
    
    init(window: UIWindow) {
        self.window = window
        self.childCoordinators = []
    }

    // Function in charge of adding Child Coordinators
    func addChildCoordinator(childCoordinator: Coordinator) {
        childCoordinators.append(childCoordinator)
    }
    
    //Function in charge of removing a Child Coordinator
    func removeChildCoordinator(childCoordinator: Coordinator) {
        
        if let index = childCoordinators.index(of: childCoordinator) {
            childCoordinators.remove(at: index)
        } else {
            fatalError("Trying to remove not existing child coordinator")
        }
    }
    
    // Override this function to start the coordinator
    func start () {
    }
}
