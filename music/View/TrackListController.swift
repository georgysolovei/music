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
        (viewModel as! TrackListViewModel).tracks.bind (listener: {_ in
            self.tableView.reloadData()
        })
    }
}

extension TrackListController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tracksCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrackCell") as! TrackCell
        cell.track = viewModel.trackAt(index: indexPath.row)
        return cell
    }
}

extension TrackListController : UITableViewDelegate {
    
}
