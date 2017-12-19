//
//  AlbumController.swift
//  music
//
//  Created by mac-167 on 11/22/17.
//  Copyright © 2017 mac-167. All rights reserved.
//

import UIKit
import Kingfisher
import RxSwift
import NVActivityIndicatorView

class ArtistController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var logOutButton: UIBarButtonItem!
    
    var artistViewModel : ArtistViewModelProtocol!
    var disposeBag : DisposeBag!
    struct Const {
        static let cell = "ArtistCell"
    }
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(ArtistController.handleRefresh), for: UIControlEvents.valueChanged)
        refreshControl.tintColor = OrangeColor

        return refreshControl
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.addSubview(self.refreshControl)
        navigationController?.navigationBar.tintColor = OrangeColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = false
        navigationItem.backBarButtonItem?.title = ""
        
        setupObservables()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = true
        disposeBag = nil
    }
    
    // MARK: - Methods
    @objc func handleRefresh() {
        artistViewModel.refresh()
    }
    
    fileprivate func updateTableViewWith(_ newIndexPaths:[IndexPath]) {
        
        if artistViewModel.isRefreshing.value {
            self.tableView.reloadData()
            self.artistViewModel.isRefreshing.value = false
        } else {
            self.tableView.beginUpdates()
            self.tableView.insertRows(at: newIndexPaths, with: .none)
            self.tableView.endUpdates()
        }
    }
    
    private func setupObservables() {
        disposeBag = DisposeBag()
      
        artistViewModel
            .newIndexPaths
            .asObservable()
            .skip(1)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { indexPaths in
                guard let newIndexPaths = indexPaths else { return }
                self.updateTableViewWith(newIndexPaths)
            })
            .disposed(by: disposeBag)
        
        logOutButton.rx
            .tap
            .asObservable()
            .bind(to: artistViewModel.logOutTapped)
            .disposed(by: disposeBag)
        
        artistViewModel
            .isLoading
            .asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { isLoading in
                isLoading == true ? self.startActivityIndicator() : self.stopActivityIndicator()
            })
            .disposed(by: disposeBag)
        
        artistViewModel
            .isRefreshing
            .asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { isRefreshing in
                if isRefreshing == false {
                    self.refreshControl.endRefreshing()
                }
            })
            .disposed(by: disposeBag)
        
        artistViewModel.errorMessage
            .asObservable()
            .skip(1)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { errorMessage in
                self.showAlert(title: Global.error, message: errorMessage!)
            })
            .disposed(by: disposeBag)
    }
}

extension ArtistController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let artistViewModel = artistViewModel else { return 0 }
        return artistViewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Const.cell) as! ArtistCell
        cell.viewModel = artistViewModel.getArtistCellViewModelFor(indexPath.row)
        return cell
    }
}

extension ArtistController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        artistViewModel?.didSelectItemAt(indexPath.row)
    }
}

extension ArtistController : UITableViewDataSourcePrefetching {
    
    // TODO: Magic Numbers
    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard let artistCount = artistViewModel?.numberOfRows else { return }
        if indexPaths.last?.row == artistCount - 50 || indexPaths.last?.row == artistCount - 1 || indexPaths.last?.row == artistCount - 30 {
            artistViewModel?.loadMore()
        }
    }
}
