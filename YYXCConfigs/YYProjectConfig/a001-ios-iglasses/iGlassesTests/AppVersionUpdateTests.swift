//
//  AppVersionUpdateTests.swift
//  iGlassesTests
//
//  Created by xian punan on 2021/5/13.
//

import XCTest
import RxBlocking
import RxSwift
import RxTest
@testable import iGlasses

class AppVersionUpdateTests: CommonTests {
    
    let testService = GlassesRemoteServiceImpl(test: true)
    let realService = GlassesRemoteServiceImpl()
    
    override func setUp() {
        GlassesUnitTest.enable = true
        super.setUp()
    }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test01_testCheckAppVersionApiFromRemoteServer() throws {
        let source = realService.checkAppVersion("1.0.0", code: 1)
        let response = try source.toBlocking(timeout: 10).first()!
        XCTAssertTrue(response.latestVersion == "1.0.1")
    }
    
}
