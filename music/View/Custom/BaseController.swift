//
//  BaseController.swift
//  music
//
//  Created by mac-167 on 1/9/18.
//  Copyright © 2018 mac-167. All rights reserved.
//

import UIKit

class BaseController : UIViewController {
    
    private struct Const {
        static let offlineViewHeight : CGFloat = 45
    }
    
    public func showOfflineView() {
        let offlineView = UINib(nibName: "OfflineView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
        view.addSubview(offlineView)
        setupConstraintsFor(offlineView)
        
        for view in view.subviews {
            if view is UITableView {
                
                view.frame.origin.y += 40
            }
        }
    }
    
    public func hideOfflineView() {
        
    }
    
    private func setupConstraintsFor(_ offlineView:UIView) {
        offlineView.translatesAutoresizingMaskIntoConstraints = false
        offlineView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        offlineView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        offlineView.heightAnchor.constraint(equalToConstant: Const.offlineViewHeight).isActive = true
    }
}
