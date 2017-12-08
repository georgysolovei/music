//
//  SongController.swift
//  music
//
//  Created by mac-167 on 11/29/17.
//  Copyright © 2017 mac-167. All rights reserved.
//

import UIKit
import RxSwift
import NVActivityIndicatorView

class TrackListController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var customNavBar: UINavigationBar!
    
    var viewModel : TrackListViewModelProtocol!
    let disposeBag = DisposeBag()

    struct Const {
        static let trackCell = "TrackCell"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backButton.tintColor = UIColor.orange
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        (viewModel as! TrackListViewModel).tracks
            .asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe({ _ in
            self.tableView.reloadData()
        }).disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.navigationBar.topItem?.title = viewModel.artistName
        customNavBar.topItem?.title = viewModel.artistName
        viewModel?.isLoading
            .asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { isLoading in
                isLoading == true ? self.startActivityIndicator() : self.stopActivityIndicator()
            })
            .disposed(by: disposeBag)
        
        viewModel.errorMessage
            .asObservable()
            .skip(1)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { errorMessage in
                self.showAlert(title: "Error", message: errorMessage!)
            })
            .disposed(by: disposeBag)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: Const.trackCell) as! TrackCell
        cell.track = viewModel.trackAt(index: indexPath.row)
        return cell
    }
}

extension TrackListController : UITableViewDelegate {
    
}
