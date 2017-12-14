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
    @IBOutlet weak var logInButton: LogInButton!
    
    var viewModel: LoginViewModelProtocol!
    var disposeBag: DisposeBag!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true

        logInButton.isEnabled = false
        disposeBag = DisposeBag()
        
        viewModel.isValid
            .asObservable()
            .bind(onNext: { isEnabled in
                self.logInButton.isEnabled = isEnabled
        })
            .disposed(by: disposeBag)
        
        logInButton.rx
            .tap
            .asObservable()
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
                self.showAlert(title: Global.error, message: errorMessage!)
            })
            .disposed(by: disposeBag)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
        disposeBag = nil
    }
    
    // MARK: - IB Actions
    @IBAction func didTapOnView(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}

// MARK: - Extensions
extension LogInController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if logInButton.isEnabled {
            view.endEditing(true)
            viewModel.buttonPressed.onNext(())
        }
        return true
    }
}
