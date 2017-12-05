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
}

final class LogInViewModel {
    var loginModel : LogInModel
    var sessionKey : Variable<String?> = Variable(nil)
    let disposeBag = DisposeBag()

    init() {
        loginModel = LogInModel()
    }
}

extension LogInViewModel : LoginViewModelProtocol {
    func logIn(userName: String, pass: String) {
        RequestManager.getMobileSession(userName: userName, password: pass).subscribe(onNext: { event in
            if !isNilOrEmpty(event) {
                self.loginModel.saveSessionKey(event!)
                self.sessionKey.value = event!
            }
        }, onError: { error in
            Spinner.shared.stop()
            AlertManager.showAlert(title: "Error", message: "Login failed")
            print(error.localizedDescription)
        }).disposed(by: disposeBag)
    }
}
