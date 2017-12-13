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
    var isLoading:    Variable<Bool>   { get }
    var errorMessage: Variable<String?>{ get }
    var username:     Variable<String?>{ get }
    var password:     Variable<String?>{ get }
    var isValid:      Observable<Bool> { get }
    var buttonPressed: PublishSubject<Void>{ get }
}

final class LogInViewModel {
    var isLoading    = Variable(false)
    var errorMessage = Variable<String?>(nil)
    var username     = Variable<String?>(nil)
    var password     = Variable<String?>(nil)
    var sessionKey   = Variable<String?>(nil)
    var isValid: Observable<Bool>
    var buttonPressed = PublishSubject<Void>()

    let loginModel : LogInModel
    let disposeBag = DisposeBag()


    init() {
        loginModel = LogInModel()
        isValid = Observable.combineLatest(self.username.asObservable(), self.password.asObservable()) { (username, password) in
            guard let username = username else { return false }
            guard let password = password else { return false }

            return username.count > 0 && password.count > 0
        }
        
        buttonPressed.subscribe(onNext: {
            self.logIn(userName: self.username.value!, pass: self.password.value!)
        }).disposed(by: disposeBag)
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
