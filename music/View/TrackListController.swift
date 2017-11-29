//
//  SongController.swift
//  music
//
//  Created by mac-167 on 11/29/17.
//  Copyright © 2017 mac-167. All rights reserved.
//

import UIKit

class TrackListController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel : TrackListViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isOpaque = true
    }
}

extension TrackListController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tracksCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

extension TrackListController : UITableViewDelegate {
    
}
