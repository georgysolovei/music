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
    var errorMessage : Variable<String?> { get }
}

final class LogInViewModel {
    var loginModel : LogInModel
    var sessionKey : Variable<String?> = Variable(nil)
    let disposeBag = DisposeBag()
    
    var errorMessage : Variable<String?> = Variable(nil)

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
            .subscribe(onNext: { event in
                if !isNilOrEmpty(event) {
                    self.loginModel.saveSessionKey(event)
                    self.sessionKey.value = event
                }
            }, onError: { error in
                print(error)
                spinner.value = false
                self.errorMessage.value = String(describing: error)
            }, onCompleted: {
                spinner.value = false
            }).disposed(by: disposeBag)
    }
}
