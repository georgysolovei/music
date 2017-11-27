//
//  DynamicString.swift
//  music
//
//  Created by mac-167 on 11/27/17.
//  Copyright © 2017 mac-167. All rights reserved.
//

class DynamicString {
    typealias Listener = (String) -> Void
    var listener: Listener?
    
    func bind(listener: Listener?) {
        self.listener = listener
    }
    
    var value: String {
        didSet {
            listener?(value)
        }
    }
    
    init(_ v: String) {
        value = v
    }
}
