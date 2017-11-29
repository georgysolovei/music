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

    var artistViewModel : ArtistViewModelProtocol?
    
    struct Const {
        static let cell = "Cell"
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        artistViewModel!.artists.bind (listener: { _ in
            self.tableView.reloadData()
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        navigationItem.backBarButtonItem?.title = ""
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = true
    }

    // MARK: - Methods

    
    // MARK: - IB Actions
    @IBAction func logOutTapped(_ sender: UIBarButtonItem) {
        artistViewModel?.logOut()
    }
    
    @IBAction func linkTapped(_ sender: UIButton) {
        let cellTapped = sender.superview!.superview
        if let indexTapped = tableView.indexPath(for: cellTapped as! ArtistCell)?.row {

            guard let artistViewModel = artistViewModel else { return }

            let artist = artistViewModel.getArtistForIndex(indexTapped)
           
            guard let link = URL(string: artist.url) else { return }
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
        guard let artistViewModel = artistViewModel else { return 0 }
        return artistViewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Const.cell) as! ArtistCell
        let cellNumber = indexPath.row
        guard let artistViewModel = artistViewModel else { return cell }

        let currentArtist = artistViewModel.getArtistForIndex(cellNumber)
        let imageUrl = URL.init(string: currentArtist.imageUrl)

        cell.artistImageView.kf.indicatorType = .activity
        cell.artistImageView.kf.setImage(with: imageUrl)
        cell.artistLabel.text = currentArtist.name
        cell.listenersCountLabel.text = String(currentArtist.listeners)
        
        return cell
    }
}

extension ArtistController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        artistViewModel?.didSelectItemAt(indexPath.row)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        guard let lastVisibleCell =  tableView.visibleCells.last else { return }
        let lastCellIndexPath = tableView.indexPath(for: lastVisibleCell)

        guard let artistViewModel = artistViewModel else { return }

        if lastCellIndexPath?.row == artistViewModel.numberOfRows - 1 {
            artistViewModel.didScrollToBottom()
        }
    }
}

class ArtistCell : UITableViewCell {
    @IBOutlet weak var artistImageView: UIImageView!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var listenersCountLabel: UILabel!
    @IBOutlet weak var linkButton: UIButton!
}