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
import RxCocoa

class LogInController: UIViewController {
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    
    var viewModel: LoginViewModelProtocol!
    var disposeBag : DisposeBag!

    private struct Const {
        static let error = "Error"
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        disableLoginButton()
        disposeBag = DisposeBag()
        
        viewModel.isValid
            .asObservable()
            .bind(onNext: { isEnabled in
                isEnabled ? self.enableLoginButton() : self.disableLoginButton()
        })
            .disposed(by: disposeBag)
        
        logInButton.rx
            .tap.asObservable()
            .bind(to: viewModel.buttonPressed)
            .disposed(by: disposeBag)
        
        (userNameField.rx.value <-> viewModel.username).disposed(by: disposeBag)
        (passwordField.rx.value <-> viewModel.password).disposed(by: disposeBag)

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
                self.showAlert(title: Const.error, message: errorMessage!)
            })
            .disposed(by: disposeBag)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
        disposeBag = nil
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
