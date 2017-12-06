//
//  Extensions.swift
//  music
//
//  Created by mac-167 on 12/6/17.
//  Copyright © 2017 mac-167. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

extension UIViewController {
    private struct Const {
        static let downsizeMultiplier : CGFloat = 7
        static let blockViewAlpha : CGFloat = 0.1
        static let activityIndicatorTag = 777
        static let blockViewTag = 666
    }

    func startActivityIndicator() {
       
        guard let unwrappedWindow = AppWindow else { return }
        guard let window = unwrappedWindow else { return }
        
        let blockView = UIView.init(frame: window.frame)
        blockView.backgroundColor = UIColor.black
        blockView.alpha = Const.blockViewAlpha
        blockView.tag = Const.blockViewTag
        view.addSubview(blockView)
        // window.addSubview(blockView)
        
        if let indicator = self.view.subviews.filter( { $0.tag == Const.activityIndicatorTag }).first as? NVActivityIndicatorView {
            indicator.startAnimating()
            
        } else {
            let width  = window.frame.width/Const.downsizeMultiplier
            let height = window.frame.height/Const.downsizeMultiplier
            let indicatorFrame = CGRect(x: window.frame.midX - width/2, y: window.frame.midY - height/2, width: width, height: height)
            let indicator = NVActivityIndicatorView(frame: indicatorFrame, type: .lineScale, color: UIColor.orange, padding: 0)
            indicator.startAnimating()
            indicator.tag = Const.activityIndicatorTag
            view.addSubview(indicator)
//            window.addSubview(indicator)
        }
    }
    
    func stopActivityIndicator() {
//        guard let unwrappedWindow = AppWindow else { return }
//        guard let window = unwrappedWindow else { return }
        
        if let indicator = self.view.subviews.filter( { $0.tag == Const.activityIndicatorTag }).first as? NVActivityIndicatorView,
            let blockView = self.view.subviews.filter( { $0.tag == Const.blockViewTag }).first {
            indicator.stopAnimating()
            blockView.removeFromSuperview()
        }
    }
}
