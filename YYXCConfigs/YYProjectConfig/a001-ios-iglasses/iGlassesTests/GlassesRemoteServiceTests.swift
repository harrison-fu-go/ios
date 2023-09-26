//
//  GlassesRemoteServiceTests.swift
//  iGlassesTests
//
//  Created by Matthew on 2021/4/24.
//

import XCTest
import RxBlocking
import RxSwift
import RxTest
@testable import iGlasses

class GlassesRemoteServiceTests: CommonTests {
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

    func test01_testCheckAppVersionApi() throws {
        let source = testService.checkAppVersion("1.0.0", code: 1)
        let response = try source.toBlocking(timeout: 10).first()!
        XCTAssertTrue(response.latestVersion == "1.0.1")
    }
    
    func test02_testDownloadFiremware() throws {
        let expection = self.expectation(description: "download finish")
        let source = realService.downloadFile(url:"https://upyuns.mcloc.cn/bing/28-May-2021/28-May-2021.jpg")
        let result = source.observe(on:MainScheduler.asyncInstance).subscribe(onNext: { (pr) in
            print(pr.progress)
            if pr.completed {
                print("finish")
            }
        }, onError: { (error) in
            print(error)
        }, onCompleted: {
            expection.fulfill()
        })
        result.disposed(by: self.disposeBag)
        self.wait(for: [expection], timeout: 120)
    }
    
    func test03_testCheckFirmwareVersionApi() throws {
       
        let expection = self.expectation(description: "check firmware version finish")
        let source = testService.checkFirmwareVersion("0.1.0", code: 1)
        let result = source.subscribe(onSuccess: { (reponse) in
            XCTAssertTrue(reponse.lastestVersion == "1.0.0")
            expection.fulfill()
        }, onFailure: { (error) in
            print(error)
            
        })
        result.disposed(by: self.disposeBag)
        self.wait(for: [expection], timeout: 5)
       
    }

    override func tearDown() {
        GlassesUnitTest.enable  = false
    }

}
