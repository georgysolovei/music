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
    var cellNumber: Int { get }
}

class ArtistCellViewModel : ArtistCellViewModelProtocol {
    var cellNumber: Int
    
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
    
    var artistCellModel = ArtistCellModel()
    private var artist: Artist
    
    init(_ artist:Artist, cellNumber:Int) {
        self.artist = artist

        self.cellNumber = cellNumber
        linkTapped
            .asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: {event in
                self.link.value = artist.url
            }).disposed(by: disposeBag)
    }
}
