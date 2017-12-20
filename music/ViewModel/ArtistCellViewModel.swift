//
//  ArtistCellViewModel.swift
//  music
//
//  Created by mac-167 on 12/15/17.
//  Copyright © 2017 mac-167. All rights reserved.
//
import RxSwift

protocol ArtistCellViewModelProtocol : class {
    var artistName:     String? { get }
    var listenersCount: String? { get }
    
    var imageLink:  String? { get }
    var linkTapped: PublishSubject<Void> { get }
    var link:       Variable<String?> { get }
}

class ArtistCellViewModel : ArtistCellViewModelProtocol {
    var linkTapped = PublishSubject<Void>()
    let disposeBag = DisposeBag()
    var link = Variable<String?>(nil)
    var artistName: String? {
       return artist.name
    }
    var listenersCount: String? {
        return artist.listeners
    }
    var imageLink: String? {
        return self.artist.imageUrl
    }
    
    private var artist: Artist
    
    init(_ artist:Artist) {
        self.artist = artist
        linkTapped
            .asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: {event in
                self.link.value = artist.url
          //      self.link.value = nil
            }).disposed(by: disposeBag)
    }
    

}
