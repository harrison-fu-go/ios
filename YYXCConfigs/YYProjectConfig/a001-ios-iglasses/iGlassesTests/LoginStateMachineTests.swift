//
//  LoginStateMachineTests.swift
//  iGlassesTests
//
//  Created by Matthew on 2021/4/20.
//

import XCTest
import RxBlocking
import RxSwift
import RxTest
@testable import iGlasses

class LoginStateMachineTests: CommonTests {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test01_testLoginStateMachineInitialStateIsUnlogin() throws {
        XCTAssert(LoginStateMachine.default.state == .unlogin)
    }
    
    func test02_testLoginStateMachineCanTransitionToLogin() throws {
        LoginStateMachine.default.state = .logedin
        XCTAssert(LoginStateMachine.default.state == .logedin)
    }
    
    func test03_testLoginStateMachineWhenTransitionStateShouldReceiveNotify() throws {
//        self.scheduler.createObserver(LoginState.self)
//        LoginStateMachine.default.delegate.subject
        
        let recorder = scheduler.createObserver((from: LoginState, to: LoginState).self)
        let source = LoginStateMachine.default.delegate.subject
        source.subscribe(recorder).disposed(by: disposeBag)
        
        let process = {
            LoginStateMachine.default.state = .unlogin
        }
        
        scheduler.createColdObservable([.next(0, ())])
            .subscribe(onNext: {
                process()
            })
            .disposed(by: disposeBag)

        scheduler.start()
        
//        let expected = Recorded(time: 0, value: Event.next((from: LoginState.logedin, to: LoginState.unlogin)))
//        XCTAssertEqual(recorder.events, expected)
        print(recorder.events)
        XCTAssert(recorder.events[0].value.element!.from == .logedin
                    && recorder.events[0].value.element!.to == .unlogin)
        
        
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
