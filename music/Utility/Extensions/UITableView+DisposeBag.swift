//
//  UITableView+DisposeBag.swift
//  music
//
//  Created by mac-167 on 12/18/17.
//  Copyright © 2017 mac-167. All rights reserved.
//

import RxSwift
private var prepareForReuseBag: Int8 = 0

extension Reactive where Base: UITableViewCell {
    var prepareForReuse: Observable<Void> {
        return Observable.of(sentMessage(#selector(UITableViewCell.prepareForReuse)).map { _ in () }, deallocated).merge()
    }
    
    var disposeBag: DisposeBag {
        MainScheduler.ensureExecutingOnScheduler()
        
        if let bag = objc_getAssociatedObject(base, &prepareForReuseBag) as? DisposeBag {
            return bag
        }
        
        let bag = DisposeBag()
        objc_setAssociatedObject(base, &prepareForReuseBag, bag, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        
        _ = sentMessage(#selector(UITableViewCell.prepareForReuse))
            .subscribe(onNext: { [weak base] _ in
                let newBag = DisposeBag()
                objc_setAssociatedObject(base as Any, &prepareForReuseBag, newBag, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            })
        
        return bag
    }
}
