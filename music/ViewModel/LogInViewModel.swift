//
//  LogInViewModel.swift
//  music
//
//  Created by mac-167 on 11/27/17.
//  Copyright © 2017 mac-167. All rights reserved.
//
protocol LoginViewModelProtocol {
    func logIn(userName:String, pass:String)
}

final class LogInViewModel {
    var loginModel : LogInModel!
    init() {
        loginModel = LogInModel()
        sessionKey = DynamicString("")
    }
    
    var sessionKey : DynamicString
}

extension LogInViewModel : LoginViewModelProtocol {
    func logIn(userName: String, pass: String) {
        RequestManager.getMobileSession(userName: userName, password: pass, success: { response in
            
            if let sessionKey = response as? String {
                self.loginModel.saveSessionKey(sessionKey)
                self.sessionKey.value = sessionKey
                // self.performSegue(withIdentifier: Const.albumSegue, sender: self)
            }
            
        }, failure: { error in
            print(error)
            
            // TODO: replace to Alert Manager
            //            let alertController = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
            //            let ok = UIAlertAction(title: "OK", style: .default) { (result : UIAlertAction) -> Void in }
            //            alertController.addAction(ok)
            //            self.present(alertController, animated: true, completion: nil)
        })
    }
}


