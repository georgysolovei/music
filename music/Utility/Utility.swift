//
//  Utility.swift
//  music
//
//  Created by mac-167 on 11/20/17.
//  Copyright © 2017 mac-167. All rights reserved.
//

import UIKit
import RxSwift

let ApiKey = "4f9192f1780beda512a56b2bea792be0"
let SecretKey = "0ff85c899eef572bf1626832c1c69ca1"

let backgroundScheduler = ConcurrentDispatchQueueScheduler(qos: .background)

let AppWindow = UIApplication.shared.delegate?.window
//let LoadingBackgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.2)
let OrangeColor = UIColor.orange

func isNilOrEmpty(_ value : String?) -> Bool {
    return (value == nil) || value!.isEmpty
}

func isNilOrEmpty<T: Collection>(_ value : T?) -> Bool {
    return (value == nil) || value!.isEmpty
}
