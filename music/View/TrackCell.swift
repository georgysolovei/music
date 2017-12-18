//
//  TrackCell.swift
//  music
//
//  Created by Georgy Solovei on 11/29/17.
//  Copyright © 2017 mac-167. All rights reserved.
//

import UIKit
import RxSwift
class TrackCell: UITableViewCell {
    @IBOutlet weak var trackImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var playCountLabel: UILabel!
    @IBOutlet weak var listenersLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    
    var disposeBag : DisposeBag!

    var viewModel: TrackCellViewModel? {
        didSet {
            disposeBag = DisposeBag()
            nameLabel.text      = viewModel?.trackName
            playCountLabel.text = viewModel?.playCount
            listenersLabel.text = viewModel?.listenersCount
            rankLabel.text      = viewModel?.rank
            nameLabel.textColor = viewModel?.textColor
        }
    }
}
