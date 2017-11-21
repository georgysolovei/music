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
    @IBOutlet weak var passwordFieldCenterYconstraint: NSLayoutConstraint!
    
    var passFieldConstraintNormalValue : CGFloat?
    
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
        subscribeForKeyboardNotifications()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if passFieldConstraintNormalValue == nil {
            passFieldConstraintNormalValue = passwordFieldCenterYconstraint.constant
        }
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
    
    func subscribeForKeyboardNotifications()  {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications()  {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        if let info = notification.userInfo {
            let keyboardSize = (info[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size
            
            guard let keyboardHeight = keyboardSize?.height else { return }

            let isKeyboardOverlaps = keyboardHeight > (view.frame.maxY - logInButton.frame.maxY) ? true : false
            
            if isKeyboardOverlaps {
                let overlapValue = keyboardHeight - (view.frame.maxY - logInButton.frame.maxY)

                passwordFieldCenterYconstraint.constant = -overlapValue
                view.layoutIfNeeded()
            }
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        if passwordFieldCenterYconstraint.constant != passFieldConstraintNormalValue! {
            passwordFieldCenterYconstraint.constant = passFieldConstraintNormalValue!
            view.layoutIfNeeded()
        }
    }
    
    func login() {
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
    
    // MARK: - IB Actions
    @IBAction func didTapOnView(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func logInTapped(_ sender: UIButton) {
        login()
    }
}

extension LogInController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == userNameField {
            passwordField.becomeFirstResponder()
        } else {
            if logInButton.isEnabled {
                view.endEditing(true)
                login()
            }
        }
        return true
    }
}
