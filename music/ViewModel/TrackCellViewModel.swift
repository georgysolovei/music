//
//  TrackCellViewModel.swift
//  music
//
//  Created by mac-167 on 12/15/17.
//  Copyright © 2017 mac-167. All rights reserved.
//

class TrackCellViewModel {
   
    var trackName: String?
    var playCount: String?
    var listenersCount: String?
    var rank: String?
    var textColor = OrangeColor
  //  nameLabel.textColor = OrangeColor
    
    private var track: Track

    init(_ track:Track) {
        self.track = track
        trackName = track.name
        playCount = track.playcount
        listenersCount = track.listeners
        rank = track.rank
    }
}
