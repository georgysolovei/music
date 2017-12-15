//
//  ArtistCell.swift
//  music
//
//  Created by mac-167 on 12/14/17.
//  Copyright © 2017 mac-167. All rights reserved.
//

import UIKit

class ArtistCell: UITableViewCell {
        @IBOutlet weak var artistImageView: UIImageView!
        @IBOutlet weak var artistLabel: UILabel!
        @IBOutlet weak var listenersCountLabel: UILabel!
        @IBOutlet weak var linkButton: UIButton!
    
    var viewModel: ArtistCellViewModel? {
        didSet {
            if let urlString = viewModel!.link {
                let imageUrl = URL.init(string: urlString)
                artistImageView.kf.indicatorType = .activity
                artistImageView.kf.setImage(with: imageUrl)
            }
            artistLabel.text = viewModel!.artistName
            listenersCountLabel.text = viewModel!.listenersCount
        }
    }
}
