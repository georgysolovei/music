//
//  Utility.swift
//  music
//
//  Created by mac-167 on 11/20/17.
//  Copyright © 2017 mac-167. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

let ApiKey = "4f9192f1780beda512a56b2bea792be0"
let SecretKey = "0ff85c899eef572bf1626832c1c69ca1"

let backgroundScheduler = ConcurrentDispatchQueueScheduler(qos: .background)
let OrangeColor = UIColor.orange

struct Global {
    static let error = "Error"
}

func isNilOrEmpty(_ value : String?) -> Bool {
    return (value == nil) || value!.isEmpty
}

func isNilOrEmpty<T: Collection>(_ value : T?) -> Bool {
    return (value == nil) || value!.isEmpty
}

func associatedObject<ValueType: AnyObject>(base: AnyObject, key: UnsafePointer<String>, initialiser: () -> ValueType) -> ValueType {
    if let associated = objc_getAssociatedObject(base, key) as? ValueType {
        return associated
    }
    let associated = initialiser()
    objc_setAssociatedObject(base, key, associated, .OBJC_ASSOCIATION_RETAIN)
    return associated
}

func associateObject<ValueType: AnyObject>(base: AnyObject, key: UnsafePointer<String>, value: ValueType) {
    objc_setAssociatedObject(base, key, value, .OBJC_ASSOCIATION_RETAIN)
}

// Bidirectional binding
infix operator <-> : DefaultPrecedence
func <-> <T>(property: ControlProperty<T>, variable: Variable<T>) -> Disposable{
    let bindToUIDisposable = variable.asObservable()
        .bind(to: property)
    
    let bindToVariable = property
        .subscribe(onNext: { n in
            variable.value = n
        }, onCompleted:  {
            bindToUIDisposable.dispose()
        })
    
    return Disposables.create(bindToUIDisposable, bindToVariable)
}

func performOnMainThread(_ closure: @escaping () -> Void) {
    if Thread.isMainThread {
        closure()
    }
    else {
        DispatchQueue.main.async(execute: closure)
    }
}
