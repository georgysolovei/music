//
//  ArtistCoordinator.swift
//  music
//
//  Created by mac-167 on 11/28/17.
//  Copyright © 2017 mac-167. All rights reserved.
//

import UIKit
import RxSwift

protocol TransitionProtocol : class {
    func transitionToArtist(_ artist: Artist)
}

protocol TrackListCoordinatorDelegate : class {
    func didFinishTrackList()
}

class ArtistCoordinator  {
    
    var navigationController : UINavigationController?
    weak var window: UIWindow!
    weak var authDelegate : AuthDelegate!
    var disposeBag = DisposeBag()

    var childCoordinators = [Any]()
    
    init(window: UIWindow) {
        self.window = window
    }
}

extension ArtistCoordinator : CoordinatorProtocol {
    func start() {
        
        navigationController = R.storyboard.artist.instantiateInitialViewController()
        window.rootViewController = navigationController
        
        let artistViewModel = AtristViewModel()
        artistViewModel.transitionDelegate = self
        
        let artistController = navigationController?.childViewControllers.first as! ArtistController
        artistController.artistViewModel = artistViewModel

        artistViewModel.link
            .asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { event in
                guard let stringUrl = event?.description else { return }
                guard let link = URL(string: stringUrl) else { return }
                UIApplication.shared.open(link, options: [:], completionHandler: nil)
            })
            .disposed(by: disposeBag)
        
        artistViewModel.isFinished.asObservable().subscribe(onNext: { event in
            if event == true {
                self.finish()
            }
        }).disposed(by: disposeBag)
    }
    
    func finish() {
        authDelegate.logOut()
    }
}

extension ArtistCoordinator : TransitionProtocol {

    func transitionToArtist(_ artist: Artist) {
        let trackListCoorinator = TrackListCoordinator(window: window, artist:artist)
        trackListCoorinator.start()
        trackListCoorinator.trackListDelegate = self
        childCoordinators.append(trackListCoorinator)
    }
}

extension ArtistCoordinator : TrackListCoordinatorDelegate {
   
    func didFinishTrackList() {
        navigationController?.popViewController(animated: true)
        childCoordinators.removeAll()
    }
}
