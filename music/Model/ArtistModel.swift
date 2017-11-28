//
//  ArtistModel.swift
//  music
//
//  Created by mac-167 on 11/27/17.
//  Copyright © 2017 mac-167. All rights reserved.
//

final class ArtistModel {
    func deleteSessionKey() {
        PersistencyManager.shared.deleteSessionKey()
    }
    
    func getSessionKey() -> String? {
        return PersistencyManager.shared.getSessionKey()
    }
}
