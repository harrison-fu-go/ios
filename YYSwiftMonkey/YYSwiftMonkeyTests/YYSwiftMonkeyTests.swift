//
//  YYSwiftMonkeyTests.swift
//  YYSwiftMonkeyTests
//
//  Created by HarrisonFu on 2022/7/14.
//

import XCTest
import SwiftMonkey
@testable import YYSwiftMonkey

class YYSwiftMonkeyTests: XCTestCase {
    
    override class func setUp() {
        super.setUp()
        XCUIApplication().launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testMonkey() {
        let application = XCUIApplication()
        
        // Workaround for bug in Xcode 7.3. Snapshots are not properly updated
        // when you initially call app.frame, resulting in a zero-sized rect.
        // Doing a random query seems to update everything properly.
        // TODO: Remove this when the Xcode bug is fixed!
        _ = application.descendants(matching: .any).element(boundBy: 0).frame
        
        let buttons = application.buttons
        debugPrint("=========== \(buttons)")
        
        
        
        // Initialise the monkey tester with the current device
        // frame. Giving an explicit seed will make it generate
        // the same sequence of events on each run, and leaving it
        // out will generate a new sequence on each run.
        let monkey = Monkey(frame: application.frame)
        //let monkey = Monkey(seed: 123, frame: application.frame)
        
        // Add actions for the monkey to perform. We just use a
        // default set of actions for this, which is usually enough.
        // Use either one of these but maybe not both.
        // XCTest private actions seem to work better at the moment.
        // UIAutomation actions seem to work only on the simulator.
        monkey.addDefaultXCTestPrivateActions()
        //monkey.addDefaultUIAutomationActions()
        
        // Occasionally, use the regular XCTest functionality
        // to check if an alert is shown, and click a random
        // button on it.
        monkey.addXCTestTapAlertAction(interval: 10000, application: application)
        
        // Run the monkey test indefinitely.
        monkey.monkeyAround()
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
