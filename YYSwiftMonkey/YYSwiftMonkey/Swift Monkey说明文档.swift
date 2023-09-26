//
//  Swift Monkey说明文档.swift
//  YYSwiftMonkey
//
//  Created by HarrisonFu on 2023/2/17.
//

import Foundation


/**
 
 1. Swift Monkey 在 跑的时候，出现证书不正确：
    解决： 设置 Scheme 的 Test 模式为： Debug模式
 
  2. 使用 addDefaultXCTestPublicActions 代替私有的Api
 
 
 
 配置过程：
 
    1. Pods 设置：
 
    2. UI Test 代码：XCUIApplication().launch() 这个要加上，否则无法启动
 
    override class func setUp() {
     super.setUp()
     XCUIApplication().launch()
    }
 
    3. 在AppDelegate 中设置window的👋
      let window = scene.windows[0]
      paws = MonkeyPaws(view: window)
 */
