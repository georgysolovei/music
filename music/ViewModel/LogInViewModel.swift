//
//  LogInViewModel.swift
//  music
//
//  Created by mac-167 on 11/27/17.
//  Copyright © 2017 mac-167. All rights reserved.
//

import RxSwift

protocol LoginViewModelProtocol: class {
    func logIn(userName:String, pass:String)
    var isLoading: Variable<Bool> { get }
}

final class LogInViewModel {
    var loginModel : LogInModel
    var sessionKey : Variable<String?> = Variable(nil)
    let disposeBag = DisposeBag()
    
    let isLoading = Variable(false)

    init() {
        loginModel = LogInModel()
    }
}

extension LogInViewModel : LoginViewModelProtocol {
    func logIn(userName: String, pass: String) {
        let spinner = isLoading
    
        spinner.value = true
        RequestManager.getMobileSession(userName: userName, password: pass)
          //  .observeOn(backgroundScheduler)
            .subscribe(onNext: { event in
                print(Thread.current)
                

                
                if !isNilOrEmpty(event) {
                    self.loginModel.saveSessionKey(event)
                    self.sessionKey.value = event
                }
            }, onError: { error in
                spinner.value = false
                // AlertManager.showAlert(title: "Error", message: "Login failed")
                print(error.localizedDescription)
                
            }, onCompleted: {
                spinner.value = false
            }).disposed(by: disposeBag)
    }
}
