//
//  AlbumController.swift
//  music
//
//  Created by mac-167 on 11/22/17.
//  Copyright © 2017 mac-167. All rights reserved.
//

import UIKit
import Kingfisher

class ArtistController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var artists = [Artist]()
    
    var page = 2
    
    struct Const {
        static let cell = "Cell"
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        navigationItem.backBarButtonItem?.title = ""
        
        tableView.isHidden = artists.isEmpty ? true : false

        RequestManager.getTopArtists(page: page, success: { response in
            self.artists.removeAll()
            self.artists = response
            
            self.tableView.reloadData()
            self.tableView.isHidden = self.artists.isEmpty ? true : false
            self.page += 1

        }, failure: { error in })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = true
    }

    // MARK: - Methods

    
    // MARK: - IB Actions
    @IBAction func logOutTapped(_ sender: UIBarButtonItem) {
        PersistencyManager.shared.deleteSessionKey()
        navigationController?.popViewController(animated: true)
    }
    @IBAction func linkTapped(_ sender: UIButton) {
        let cellTapped = sender.superview!.superview
        if let indexTapped = tableView.indexPath(for: cellTapped as! ArtistCell)?.row {
            guard let link = URL(string: artists[indexTapped].url) else { return }
            UIApplication.shared.open(link, options: [:], completionHandler: nil)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
extension ArtistController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return artists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Const.cell) as! ArtistCell
        let cellNumber = indexPath.row
        let currentAlbum = artists[cellNumber]
        let imageUrl = URL.init(string: currentAlbum.imageUrl)

        cell.artistImageView.kf.indicatorType = .activity
        cell.artistImageView.kf.setImage(with: imageUrl)
        cell.artistLabel.text = currentAlbum.name
        cell.listenersCountLabel.text = String(currentAlbum.listeners)
        
        return cell
    }
}

extension ArtistController : UITableViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        guard let lastVisibleCell =  tableView.visibleCells.last else { return }
        let lastCellIndexPath = tableView.indexPath(for: lastVisibleCell)
        
        if lastCellIndexPath?.row == artists.count - 1 {

            RequestManager.getTopArtists(page: page, success: { response in
            
                self.artists.append(contentsOf: response)
                self.tableView.reloadData()
                self.page += 1
            }, failure: { error in })
        }
    }
}

class ArtistCell : UITableViewCell {
    @IBOutlet weak var artistImageView: UIImageView!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var listenersCountLabel: UILabel!
    @IBOutlet weak var linkButton: UIButton!
}
