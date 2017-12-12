//
//  UIViewController+Alert.swift
//  music
//
//  Created by mac-167 on 12/12/17.
//  Copyright © 2017 mac-167. All rights reserved.
//

import UIKit
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
