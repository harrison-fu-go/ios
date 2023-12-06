//
//  YYAsyncAwaitVC.swift
//  YYSwiftLearning
//
//  Created by HarrisonFu on 2023/10/11.
//

import Foundation
import UIKit

/**
 1. 一般带callback的函数，可以在右键refactor里面转换成 async/await 的形式
    注意： a. callback 需要 @escaping来修饰
          b. 转换后多了 @available(*, renamed: "testAsyncAwait1()") 修饰的一个函数，可以删除，如果不再需要callback的形式访问。
 
 2. 访问的时候需要放到 Task 里面。
    
 3. Task 中await 会出现等待的效果，所以是串行的效果。
 
 4. Task 中的 async let 后面语块会延迟到 await 的时候再执行，所以可以实现并行的效果
 */

class YYAsyncAwaitVC : UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        //Task 中await 会出现等待的效果，所以是串行的效果。
        Task {
            let val = await self.testAsyncAwait1()
            debugPrint("sleep seconds: ===== \(val)")

            let val1 = await self.testWaitAndAsync()
            debugPrint("sleep seconds: ===== \(val1)")
        }
        
        //Task 中的 async let 后面语块会延迟到 await 的时候再执行，所以可以实现并行的效果
        Task {
            async let a =  self.testAsyncAwait1()
            async let b =  self.testWaitAndAsync()
            debugPrint("sleep seconds: ===== \(await b) \(await a)")
        }

        debugPrint("sleep seconds: ===== 0 ")
    }
    

    //必须带 @escaping 的callback返回才可以使用 async/await. 这里无法使用
    @available(*, renamed: "testAsyncAwait1()")
    func testAsyncAwait1(callback: @escaping (Int) -> Void) {
        Task {
            let result = await testAsyncAwait1()
            callback(result)
        }
    }
    
    func testAsyncAwait1() async -> Int {
        return await withCheckedContinuation { continuation in
            DispatchQueue.global().async {
                sleep(2)
                continuation.resume(returning: 2)
            }
        }
    }
    
    func testWaitAndAsync() async -> Int {
        return await withCheckedContinuation({ conti in
            DispatchQueue.global().async {
                sleep(2)
                conti.resume(returning: 2000)
            }
        })
    }
}

