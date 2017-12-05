//
//  SongController.swift
//  music
//
//  Created by mac-167 on 11/29/17.
//  Copyright © 2017 mac-167. All rights reserved.
//

import UIKit
import RxSwift

class TrackListController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    var viewModel : TrackListViewModelProtocol!
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        backButton.tintColor = UIColor.orange
        (viewModel as! TrackListViewModel).tracks.asObservable().subscribe({ _ in
            self.tableView.reloadData()
        }).disposed(by: disposeBag)
    }
    
    @IBAction func backTapped(_ sender: UIBarButtonItem) {
        viewModel.didPressBackButton()
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
