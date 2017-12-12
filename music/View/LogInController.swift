//
//  ViewController.swift
//  music
//
//  Created by mac-167 on 11/17/17.
//  Copyright © 2017 mac-167. All rights reserved.
//

import UIKit
import RxSwift
import NVActivityIndicatorView

class LogInController: UIViewController {
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    
    var viewModel: LoginViewModelProtocol!
    var disposeBag = DisposeBag()

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for textField in [userNameField, passwordField] {
            textField?.addTarget(self, action: #selector(LogInController.updateTextField), for: .editingChanged)
        }
        updateTextField()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        
        viewModel.isLoading
            .asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { isLoading in
                isLoading == true ? self.startActivityIndicator() : self.stopActivityIndicator()
            })
            .disposed(by: disposeBag)
        
        viewModel.errorMessage
            .asObservable()
            .skip(1)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { errorMessage in
                self.showAlert(title: "Error", message: errorMessage!)
            })
            .disposed(by: disposeBag)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
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
    
    func login() {
        if let user = userNameField.text, let password = passwordField.text {
            if !user.isEmpty && !password.isEmpty {
               viewModel.logIn(userName: user, pass: password)
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
