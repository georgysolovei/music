//
//  LoginButton.swift
//  music
//
//  Created by mac-167 on 12/13/17.
//  Copyright © 2017 mac-167. All rights reserved.
//
import UIKit

class LogInButton: UIButton {
    override open var isEnabled: Bool {
        didSet {
            backgroundColor = isEnabled ? OrangeColor : UIColor.lightGray
        }
    }
}
