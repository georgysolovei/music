//: Playground - noun: a place where people can play

import RxSwift
/*
example("just", action: {

    // Observable
    let stringObservable = Observable.just("Hello")

    // Observer
    stringObservable.subscribe({ (event:Event<String>) in
        print(event)
    })
})

example("of", action: {

    let observable = Observable.of(1,2,3,4,5)
    observable.subscribe{
        print($0)
    }
})

example("create", action: {
    let items = [1,2,3,4,5]
    
    Observable.from(items).subscribe(onNext: {(event) in
        print(event)
    }, onError: { (error) in
        print("ERROR")
    }, onCompleted: {
        print("completed")
    }, onDisposed: {
        print("disposed")
    })
})

example("Disposable", action: {
    let seq = [1,2,3]
    Observable.from(seq).subscribe({(event) in
        print(event)
    })
    Disposables.create()
})

example("Dispose Bag", action: {
    let disposeBag = DisposeBag()
    let seq = [1,2,3]
    let subscription = Observable.from(seq)
    subscription.subscribe({(event) in
        print(event)
    }).disposed(by: disposeBag)
})

example("Take Untill", action: {
    let stopSeq = Observable.just(1).delaySubscription(1, scheduler: MainScheduler.instance)

    let seq = Observable.from([1,2,3,4,5,6,7,8,9,10]).takeUntil(stopSeq)
    
    seq.subscribe{
        print($0)
    }
})

example("Filter", action: {
    let seq = Observable.of(1,2,20,4,45).filter{$0 > 10}
    seq.subscribe({ (event) in
        print(event)
    })
})

example("Map", action: {
    let seq = Observable.of(1,2,20,4,45).map{$0 * 10}
    seq.subscribe({ (event) in
        print(event)
    })
})

example("Merge", action: {
    let firstSeq = Observable.of(1,2,3)
    let secSeq   = Observable.of(4,5,6)
    
    let bothSeq = Observable.of(firstSeq, secSeq)
    
    let mergeSeq = bothSeq.merge()
    
    mergeSeq.subscribe({ (event) in
        print(event)
    })
})


example("Publish subject", action: {
    let disposableBag = DisposeBag()
    
    let subject = PublishSubject<String>()
    
    subject.subscribe{
        print("Subscription first", $0)
    }.disposed(by: disposableBag)
    
    subject.on(.next("Hello"))
    subject.on(.next("RxSwift"))
    
    subject.subscribe(onNext: {
        print("Subscription second",$0)
    }).disposed(by: disposableBag)
    
    subject.onNext("Hi!")
    subject.onNext("My name is D")
})

example("Behavior subject", action: {
    let disposableBag = DisposeBag()
    
    let subject = BehaviorSubject(value: 1)
    let firstSubscription = subject.subscribe(onNext: {
        print($0)
    }).disposed(by: disposableBag)
    
    subject.onNext(2)
    subject.onNext(3)
    
    let secondSubscription = subject.map({ $0 + 2 }).subscribe(onNext:{
        print($0)
    }).disposed(by: disposableBag)
})

example("Replay subject", action: {
    let disposableBag = DisposeBag()

    let subject = ReplaySubject<String>.create(bufferSize: 1)
    
    subject.subscribe {
        print("First subscription", $0)
    }.disposed(by: disposableBag)
    
    subject.onNext("A")
    subject.onNext("B")
    
    subject.subscribe {
        print("Second subscription", $0)
    }.disposed(by: disposableBag)
    
    subject.onNext("C")
    subject.onNext("D")
})


example("Variable", action: {
    let disposableBag = DisposeBag()

    let variable = Variable("A")
    
    variable.asObservable().subscribe(onNext: {
        print($0)
    }).disposed(by: disposableBag)
    
    variable.value = "B"
})

// позволяет вклиниваться между действиями операторов
example("Side Effect", action: {
    let seq = [0, 30, 100, 300]
    let disposableBag = DisposeBag()

    let tempSeq = Observable.from(seq)
    
    tempSeq.do(onNext: {
        print("\($0)F = ", terminator: "")
    }).map({
        Double($0 - 32) * 5/9.0
    }).subscribe(onNext: {
        print(String(format: "%.1f", $0))
    }).disposed(by: disposableBag)
})

example("without Observe on", action: {
    _ = Observable.of(1,2,3)
    .subscribe(onNext: {
        print("\(Thread.current): ", $0)
    }, onError: nil, onCompleted: {
        print("Completed")
    }, onDisposed: nil)
})


// указывает, на каком потоке выполнять работу
example("Observe on", action: {
    _ = Observable.of(1,2,3)
        .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
        .subscribe(onNext: {
            print("\(Thread.current): ", $0)
        }, onError: nil, onCompleted: {
            print("Completed")
        }, onDisposed: nil)
})
*/

// указывает, на каком потоке выполнять работу
example("Observe on & Subscribe on", action:  {
    let queue1 = DispatchQueue.global(qos: .default)
    let queue2 = DispatchQueue.global(qos: .default)
  
    print("Init Thread: \(Thread.current)")

    _ = Observable<Int>.create({ (observer) -> Disposable in
        
        print("Observable Thread: \(Thread.current)")
        
        observer.on(.next(1))
        observer.on(.next(2))
        observer.on(.next(3))

        return Disposables.create()
    })
        .subscribeOn(SerialDispatchQueueScheduler(internalSerialQueueName:"queue1"))
        .observeOn(SerialDispatchQueueScheduler(internalSerialQueueName:"queue2"))
        .subscribe(onNext: {
        print("Observable Thread: \(Thread.current)", $0)
    })
})
