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
 
 
 example("Empty", action: {
 let observable = Observable<Void>.empty()
 observable.subscribe(onNext: {
 
 }, onError: nil, onCompleted: {
 print("Completed")
 }, onDisposed: nil)
 })
 
 
 example("Never", action: {
 let observable = Observable<Any>.never()
 observable
 .subscribe(
 onNext: { element in
 print(element)
 },
 onCompleted: {
 print("Completed")
 }
 )
 })
 
 example("Range", action: {
 let observable = Observable<Int>.range(start: 1, count: 10)
 observable.subscribe(onNext: { i in
 let n = Double(i)
 let fibonacci = Int(((pow(1.61803, n) - pow(0.61803, n)) /
 2.23606).rounded())
 print(fibonacci)
 })
 })
 
 example("Create", action: {
 let disposeBag = DisposeBag()
 
 Observable<String>.create({ observer in
 
 observer.onNext("1")
 observer.onCompleted()
 observer.onNext("2")
 
 return Disposables.create()
 }).subscribe(onNext: { print($0) },
 onError: { print($0) },
 onCompleted: { print("Completed") },
 onDisposed: { print("Disposed") }).disposed(by: disposeBag)
 })
 
 example("Deferred", action: {
 let disposeBag = DisposeBag()
 var flip = false
 
 let factory = Observable<Int>.deferred({
 flip = !flip
 if flip {
 return Observable.of(1, 2, 3)
 } else {
 return Observable.of(4, 5, 6)
 }
 })
 
 for _ in 0...3 {
 factory.subscribe(onNext: {
 print($0, terminator:"")
 }).disposed(by: disposeBag)
 print()
 }
 })
 
 example("Publish Subject", action: {
 let subject = PublishSubject<String>()
 
 let subscriptionOne = subject.subscribe(onNext: { string in
 print(string)
 })
 subject.on(.next("Is anyone listening?"))
 subject.onNext("Yes")
 subscriptionOne.dispose()
 
 let subscriptionTwo = subject
 .subscribe { event in
 print(event.element ?? event)
 }
 subject.onNext("TTT")
 })
 
 example("BehaviorSubject") {
 // 4
 let subject = BehaviorSubject(value: "Initial value")
 let disposeBag = DisposeBag()
 subject.onNext("X")
 
 subject.subscribe({
 print(label: "1)", event: $0)
 }).disposed(by: disposeBag)
 subject.onNext("++")
 subject.subscribe({
 print(label: "2)", event: $0)
 }).disposed(by: disposeBag)
 subject.onError(MyError.anError)
 subject.onNext("--")
 }
 
 
 example("ReplaySubject") {
 // 1
 let subject = ReplaySubject<String>.create(bufferSize: 2)
 let disposeBag = DisposeBag()
 // 2
 subject.onNext("1")
 subject.onNext("2")
 subject.onNext("3")
 // 3
 subject
 .subscribe {
 print(label: "1)", event: $0)
 }
 .addDisposableTo(disposeBag)
 subject
 .subscribe {
 print(label: "2)", event: $0)
 }
 .addDisposableTo(disposeBag)
 
 subject.onNext("4")
 subject.onError(MyError.anError)
 
 subject
 .subscribe {
 print(label: "3)", event: $0)
 }
 .addDisposableTo(disposeBag)
 }


example("variable", action: {
    var variable = Variable("Initial value")
    let disposeBag = DisposeBag()
    variable.value = "value"
    variable.asObservable().subscribe({
        print("1)", separator: $0)
    }).disposed(by: disposeBag)
    // 1
    variable.value = "1"
    // 2
    variable.asObservable()
        .subscribe {
            print(label: "2)", event: $0)
        }
        .disposed(by: disposeBag)
    // 3
    variable.value = "2"
})

 */
