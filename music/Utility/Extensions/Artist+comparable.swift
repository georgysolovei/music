//
//  Artist+comparable.swift
//  music
//
//  Created by mac-167 on 12/22/17.
//  Copyright © 2017 mac-167. All rights reserved.
//

extension Artist {
    static func == (lhs: Artist, rhs: Artist) -> Bool {
        return lhs.name      == rhs.name
            && lhs.listeners == rhs.listeners
            && lhs.url       == rhs.url
            && lhs.imageUrl  == rhs.imageUrl
    }
}
