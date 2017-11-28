//
//  Spinner.swift
//  music
//
//  Created by mac-167 on 11/21/17.
//  Copyright © 2017 mac-167. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

final class Spinner {
    
    enum Position {
        case center
        case bottom
    }
    
    struct Const {
        static let downsizeMultiplier : CGFloat = 7
        static let blockViewAlpha : CGFloat = 0.07
    }
    
    let indicator : NVActivityIndicatorView
    var blockView = UIView()
    var appDelegate : AppDelegate?

    static let shared = Spinner()
    
    // MARK: - Initialization
    init() {
        indicator = NVActivityIndicatorView(frame: CGRect.zero, type: .lineScale, color: UIColor.orange, padding: 0)

        appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        guard let appDelegate = appDelegate else { return }
        guard let window = appDelegate.window else { return }
        
        let width = window.frame.width/Const.downsizeMultiplier
        let height = window.frame.height/Const.downsizeMultiplier
        
        let indicatorFrame = CGRect(x: window.frame.midX - width/2, y: window.frame.midY - height/2, width: width, height: height)
        indicator.frame = indicatorFrame
        blockView = UIView.init(frame: window.frame)
        blockView.backgroundColor = UIColor.black
        blockView.alpha = Const.blockViewAlpha
    }
    
    // MARK: - Public
    public func startAt(postion:Position = .center, isBlockUI:Bool = true) {
        indicator.startAnimating()
        blockView.isHidden = false

        guard let appDelegate = appDelegate else { return }
        guard let window = appDelegate.window else { return }
        
        window.addSubview(blockView)
        window.addSubview(indicator)
    }
    
    public func stop() {
        indicator.stopAnimating()
        blockView.isHidden = true
        
        blockView.removeFromSuperview()
        indicator.removeFromSuperview()
    }
}
