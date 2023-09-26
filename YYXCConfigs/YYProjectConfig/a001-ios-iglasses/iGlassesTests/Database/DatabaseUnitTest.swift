//
//  Database.swift
//  iGlassesTests
//
//  Created by zk-fuhuayou on 2021/5/21.
//

import XCTest
@testable import iGlasses
class DatabaseUnitTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func test01_createDatabase() {
        DatabaseCenter.sharedInstance.createTables()
    }
    
    func test02_appInfo() {
        //1. Update.
        let taskModel = DatabaseModel()
        taskModel.setAssociateValues(values: [["key": "linkAppStore", "value":"www.baidu.com"],
                                              ["key": "latestVersion", "value":"1.0.0"],
                                              ["key": "versionCode", "value":"0"],
                                              ["key": "updateDesc", "value":"test, test, test....... test"],
                                              ["key": "forceUpdate", "value":"false"],])
        DatabaseCenter.updateAppInfo(taskModel)
        
        //2. get latest version
        let latestModel = DatabaseCenter.getLatestAppInfo()
        latestModel?.printAll(reflect: DatabaseConstants.columns(of: DatabaseConstants.appInfoRecordsTable))
    }
    
    func test03_testGlobal() {
        //set.
        DatabaseCenter.updateGlobalValue(key: "TEST_KEY", value: "Test_VALUE")
        
        //get.
        var value = DatabaseCenter.globalValue(key: "TEST_KEY")
        print("================ value: ", value ?? "nil")
        
        //set to nil.
        DatabaseCenter.updateGlobalValue(key: "TEST_KEY", value: nil)
        value = DatabaseCenter.globalValue(key: "TEST_KEY")
        print("================ value: ", value ?? "nil")
        
    }
}
