//
//  AlertManager.swift
//  music
//
//  Created by Georgy Solovei on 11/19/17.
//  Copyright © 2017 mac-167. All rights reserved.
//

import UIKit
final class AlertManager {
    public class func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { (result : UIAlertAction) -> Void in
            
        }
        alertController.addAction(ok)
        alertController.show(alertController, sender: nil)
    }
}
