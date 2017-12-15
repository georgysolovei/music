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
    
    var viewModel : TrackListViewModelProtocol!
    var disposeBag : DisposeBag!

    struct Const {
        static let trackCell = "TrackCell"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()


    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     
        guard let navBar = navigationController?.navigationBar else { return }
        navBar.isHidden = false
        navBar.tintColor = OrangeColor
        navBar.topItem?.title = ""
        navigationItem.title = viewModel.artistName
        
        disposeBag = DisposeBag()
        
        viewModel
            .tracks
            .asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe({ _ in
                self.tableView.reloadData()
            }).disposed(by: disposeBag)
                
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
                self.showAlert(title: Global.error, message: errorMessage!)
            })
            .disposed(by: disposeBag)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        disposeBag = nil
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
        let trackCell = tableView.dequeueReusableCell(withIdentifier: Const.trackCell) as! TrackCell
        trackCell.viewModel = viewModel.trackCellViewModelAt(index: indexPath.row)
        return trackCell
    }
}

extension TrackListController : UITableViewDelegate {
    
}
