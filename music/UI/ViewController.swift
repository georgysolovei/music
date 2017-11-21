//
//  ViewController.swift
//  music
//
//  Created by mac-167 on 11/17/17.
//  Copyright © 2017 mac-167. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//
//        RequestManager.getMobileSession(userName: "georgenight777", password: "dreamland88!", success: {
//            print("SUCCESS")
//        }, failure: { error in
//            print(error)
//        })
        
        
        RequestManager.getTopArtists(success: {
            print("SUCCESS")
        }, failure: { error in })
    }
}

