//
//  TrackCell.swift
//  music
//
//  Created by Georgy Solovei on 11/29/17.
//  Copyright © 2017 mac-167. All rights reserved.
//

import UIKit

class TrackCell: UITableViewCell {
    @IBOutlet weak var trackImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var playCountLabel: UILabel!
    @IBOutlet weak var listenersLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    
    var track: Track? {
        didSet {
            let imageUrl = URL.init(string: track?.imageUrl ?? "")
            trackImageView.kf.setImage(with: imageUrl)
            nameLabel.text = track?.name ?? "Song name"
            playCountLabel.text = track != nil ? String(describing: track!.playcount) : ""
            listenersLabel.text = track != nil ? String(describing: track!.listeners) : ""
            rankLabel.text      = track != nil ? String(describing: track!.rank)      : ""
            
            nameLabel.textColor = UIColor.orange
        }
    }
}
