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
        
        guard let unwrappedWindow = AppWindow else { return }
        guard let window    = unwrappedWindow else { return }
        
        blockView = UIView(frame: window.frame)
        blockView.backgroundColor = UIColor.black
        blockView.alpha = Const.blockViewAlpha
        view.addSubview(blockView)

        let width  = window.frame.width/Const.downsizeMultiplier
        let height = window.frame.height/Const.downsizeMultiplier
        
        let indicatorFrame = CGRect(x: window.frame.midX - width/2, y: window.frame.midY - height/2, width: width, height: height)
        activityIndicator = NVActivityIndicatorView(frame: indicatorFrame, type: .audioEqualizer, color: UIColor.orange, padding: 0)
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    func stopActivityIndicator() {
        
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
        blockView.removeFromSuperview()
    }
}

// Alert
extension UIViewController {
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { (result : UIAlertAction) -> Void in
        }
        alertController.addAction(ok)
        alertController.show(alertController, sender: nil)
      //  guard let rootViewController = UIApplication.shared.keyWindow?.rootViewController else { return }
        self.present(alertController, animated: true, completion: nil)
    }
}



extension String: Error {}
