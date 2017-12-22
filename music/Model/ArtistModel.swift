//
//  ArtistModel.swift
//  music
//
//  Created by mac-167 on 11/27/17.
//  Copyright © 2017 mac-167. All rights reserved.
//

import RxSwift

final class ArtistModel {
    
    var rowToUpdate : Variable<Int?> = Variable(nil)
    
    func cachedArtistsFor(_ page:Int) -> [Artist]? {
        return PersistencyManager.shared.getArtistsFor(page)
    }
    
    func deleteSessionKey() {
        PersistencyManager.shared.deleteSessionKey()
    }
    
    func getSessionKey() -> String? {
        return PersistencyManager.shared.getSessionKey()
    }
    
    func cacheArtistsFor(page:Int, artists:[Artist]) {
        guard let indexes = PersistencyManager.shared.cacheArtistsFor(page: page, artists:artists) else { return }
        for artisIndex in indexes {
            rowToUpdate.value = artisIndex
        }
    }
    
    func clearCache() {
        PersistencyManager.shared.clearAll()
    }
}
