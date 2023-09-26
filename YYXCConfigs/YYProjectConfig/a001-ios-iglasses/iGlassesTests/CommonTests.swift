//
//  CommonTests.swift
//  iGlassesTests
//
//  Created by Matthew on 2021/4/20.
//

import XCTest
import RxTest
import RxSwift

class CommonTests: XCTestCase {
    
    typealias Criteria<T> = ([Recorded<Event<T>>], [Recorded<Event<T>>], StaticString, UInt) -> Void
    
    /// - Properties
    var disposeBag: DisposeBag!
    var scheduler: TestScheduler!
    
    override func setUp() {
        self.disposeBag = DisposeBag()
        self.scheduler = TestScheduler(initialClock: 0)
        super.setUp()
    }
    
    /// - Methods
    func t<T: Equatable>(
        source: Observable<T>,
        expected: [Recorded<Event<T>>],
        process: @escaping () -> Void) {
        /// 1. Create the recorder and bind it to the source observable
        let recorder = scheduler.createObserver(T.self)
        source.subscribe(recorder).disposed(by: disposeBag)
        
        /// 2. Make a `(0, Void)` event to trigger the tested `process`
        scheduler.createColdObservable([.next(0, ())])
            .subscribe(onNext: {
                process()
            })
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        /// 3. Compare the result
        XCTAssertEqual(recorder.events, expected)
    }
    
    /// In `t_c`, `T` need not to be `Equatable`. We just count the
    /// number of events, not events themselves.
    func t_c<T>(
        source: Observable<T>,
        expected: Int,
        process: @escaping () -> Void) {
        /// 1. Create the recorder and bind it to the source observable
        let recorder = scheduler.createObserver(T.self)
        source.subscribe(recorder).disposed(by: disposeBag)
        
        /// 2. Make a `(0, Void)` event to trigger the tested `process`
        scheduler.createColdObservable([.next(0, ())])
            .subscribe(onNext: {
                process()
            })
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        /// 3. Compare the result
        XCTAssertEqual(recorder.events.count, expected)
    }
}
