//
//  LoginModel.swift
//  music
//
//  Created by mac-167 on 11/27/17.
//  Copyright © 2017 mac-167. All rights reserved.
//

final class LogInModel {
    func saveSessionKey(_ key:String) {
        PersistencyManager.shared.saveSessionKey(key)
    }
    
    func deleteSessionKey() {
        
    }
}
