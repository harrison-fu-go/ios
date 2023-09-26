//
//  TestSwift1.swift
//  YYOcSwiftMix
//
//  Created by 符华友 on 2021/9/26.
//

import UIKit

class TestSwift1: NSObject {
    
    override init() {
        super.init();
        TestOc.sayHello();
    }
    
    let text = "Hello"
    @objc public func sayHello() {
        print("Hello .....")
    }
    
    
    
}
