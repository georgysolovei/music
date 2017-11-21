//
//  ViewController.swift
//  music
//
//  Created by mac-167 on 11/17/17.
//  Copyright © 2017 mac-167. All rights reserved.
//

import UIKit

class LogInController: UIViewController {
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for textField in [userNameField, passwordField] {
            textField?.addTarget(self, action: #selector(LogInController.updateTextField), for: .editingChanged)
        }
        updateTextField()
        
        
//        RequestManager.getTopArtists(success: { response in
//            print("SUCCESS")
//        }, failure: { error in })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - Methods
    func disableLoginButton() {
        logInButton.isEnabled = false
        logInButton.backgroundColor = UIColor.lightGray
    }

    func enableLoginButton() {
        logInButton.isEnabled = true
        logInButton.backgroundColor = OrangeColor

    }
    
    @objc func updateTextField() {
        let textFields = [userNameField, passwordField]

        let oneOfTheTextFieldsIsBlank = textFields.contains(where: {($0?.text ?? "").isEmpty})
        if oneOfTheTextFieldsIsBlank {
            disableLoginButton()
        } else {
            enableLoginButton()
        }
    }
    // MARK: - IB Actions
    @IBAction func logInTapped(_ sender: UIButton) {
        
        if let user = userNameField.text, let password = passwordField.text {
            
            if !user.isEmpty && !password.isEmpty {
                RequestManager.getMobileSession(userName: user, password: password, success: { response in
                    print("SUCCESS")
                }, failure: { error in
                    print(error)
                    
                    // TODO: replace to Alert Manager
                    let alertController = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
                    let ok = UIAlertAction(title: "OK", style: .default) { (result : UIAlertAction) -> Void in }
                    alertController.addAction(ok)
                    self.present(alertController, animated: true, completion: nil)
                })
            }
        }
    }
}

extension LogInController : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
}
