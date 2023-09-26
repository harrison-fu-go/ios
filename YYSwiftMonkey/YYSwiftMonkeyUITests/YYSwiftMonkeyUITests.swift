//
//  YYSwiftMonkeyUITests.swift
//  YYSwiftMonkeyUITests
//
//  Created by HarrisonFu on 2022/7/14.
//

import XCTest
import SwiftMonkey
class YYSwiftMonkeyUITests: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        let application = XCUIApplication()
        _ = application.descendants(matching: .any).element(boundBy: 0).frame
        let monkey = Monkey(frame: application.frame)
        monkey.addDefaultXCTestPublicActions(app: application)
        monkey.addXCTestTapAlertAction(interval: 100, application: application)
        monkey.monkeyAround()
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
