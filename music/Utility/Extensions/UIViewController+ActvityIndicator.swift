//
//  Extensions.swift
//  music
//
//  Created by mac-167 on 12/6/17.
//  Copyright © 2017 mac-167. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

// Activity indicator
extension UIViewController {
    private struct Const {
        static let downsizeMultiplier : CGFloat = 4
        static let blockViewAlpha : CGFloat = 0.1
        static var activityIndicatorKey = "activityIndicator"
        static var blockViewKey = "blockViewKey"
    }
    
    var activityIndicator: NVActivityIndicatorView {
        get {
            return associatedObject(base: self, key: &Const.activityIndicatorKey) {
                return NVActivityIndicatorView(frame: CGRect.zero)
            }
        }
        set {
            associateObject(base: self, key: &Const.activityIndicatorKey, value: newValue)
        }
    }
    
    var blockView: UIView {
        get {
            return associatedObject(base: self, key: &Const.blockViewKey) {
                return UIView()
            }
        }
        set {
            associateObject(base: self, key: &Const.blockViewKey, value: newValue)
        }
    }
    
    func startActivityIndicator() {
        
        let controllerFrame = view.frame
        
        blockView = UIView(frame: controllerFrame)
        blockView.backgroundColor = UIColor.black
        blockView.alpha = Const.blockViewAlpha
        view.addSubview(blockView)

        let width  = controllerFrame.width/Const.downsizeMultiplier
        let height = controllerFrame.height/Const.downsizeMultiplier
        
        let indicatorFrame = CGRect(x: controllerFrame.midX - width/2, y: controllerFrame.midY - height/2, width: width, height: height)
        activityIndicator = NVActivityIndicatorView(frame: indicatorFrame, type: .audioEqualizer, color: OrangeColor, padding: 0)
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    func stopActivityIndicator() {
        
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
        blockView.removeFromSuperview()
    }
}
