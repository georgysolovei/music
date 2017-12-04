//
//  LogInViewModel.swift
//  music
//
//  Created by mac-167 on 11/27/17.
//  Copyright © 2017 mac-167. All rights reserved.
//

protocol LoginViewModelProtocol: class {
    func logIn(userName:String, pass:String)
}

final class LogInViewModel {
    var loginModel : LogInModel!
    var sessionKey : Dynamic<String?> = Dynamic(nil)

    init() {
        loginModel = LogInModel()
        sessionKey = Dynamic(nil)
        
        if let key = PersistencyManager.shared.getSessionKey() {
            sessionKey.value = key
        }
    }
}

extension LogInViewModel : LoginViewModelProtocol {
    func logIn(userName: String, pass: String) {
//        RequestManager.getMobileSession(userName: userName, password: pass, success: { response in
//            if let sessionKey = response as? String {
//                self.loginModel.saveSessionKey(sessionKey)
//                self.sessionKey.value = sessionKey
//            }
//        }, failure: { error in
//            print(error)
//            AlertManager.showAlert(title: "Error", message: error)
//        })
        RequestManager.getMobileSession(userName: userName, password: pass)
    }
}


