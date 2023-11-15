//
//  YYAsyncAwaitVC.swift
//  YYSwiftLearning
//
//  Created by HarrisonFu on 2023/10/11.
//

import Foundation
import UIKit

struct YYSuccess: Sendable {
    
}

struct YYError: Error {
    
}

class YYAsyncAwaitVC : UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        let aTask = Task {
            let val = await self.testAsyncAwait()
            debugPrint("sleep seconds: ===== \(val)")
        }
        debugPrint("sleep seconds: ===== 0 ")
    }
    
    deinit {
//        if let aTask = aTask as? Task<<#Success: Sendable#>, <#Failure: Error#>> {
//            aTask.cancel()
//        }
    }

    @available(*, renamed: "testAsyncAwait()")
    func testAsyncAwait(callback: @escaping (Int) -> Void) {
        Task {
            let result = await testAsyncAwait()
            callback(result)
        }
    }
    
    func testAsyncAwait() async -> Int {
        return await withCheckedContinuation { continuation in
            DispatchQueue.global().async {
                sleep(5)
                continuation.resume(returning: 5)
            }
        }
    }

    //必须带 @escaping 的callback返回才可以使用 async/await. 这里无法使用
    func testAsyncAwait1(callback: ((Int) -> Void)?) {
        DispatchQueue.global().async {
            sleep(2)
            callback?(2)
        }
    }
}
