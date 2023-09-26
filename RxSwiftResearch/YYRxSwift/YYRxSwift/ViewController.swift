//
//  ViewController.swift
//  YYRxSwift
//
//  Created by zk-fuhuayou on 2021/6/10.
//

import UIKit
import RxSwift
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        /**
         源码研究
         */
        // 1: 创建序列
        _ = Observable<String>.create { (obserber) -> Disposable in
            // 3:发送信号
            obserber.onNext("Cooci -  框架班级")
            return Disposables.create()  // 这个销毁不影响我们这次的解读
            // 2: 订阅序列
        }.subscribe(onNext: { (text) in
            print("订阅到:\(text)")
        })
    }
}

