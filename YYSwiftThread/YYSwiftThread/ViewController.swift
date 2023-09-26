//
//  ViewController.swift
//  YYSwiftThread
//
//  Created by HarrisonFu on 2022/10/13.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        asyncBarrier()

    }
    
    func asyncBarrier() {
        
        let group = DispatchGroup()
        let queue = DispatchQueue.global()
        
        group.enter()
        queue.async {
            print("group - group111111: \(Thread.current)")
            group.leave()
        }
        
        group.enter()
        queue.async {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                print("group - group222222: \(Thread.current)")
                group.leave()
            }
        }
        
        group.notify(queue: queue) {
            print("group - group3333333: \(Thread.current)")
        }
    }


    
    func testBarrier() {
        let queue = DispatchQueue(label: "rw_queue", attributes: .concurrent)
        queue.async {
            print("barrier - async111: \(Thread.current)")
        }

        queue.async {
            print("barrier - async222: \(Thread.current)")
            for _ in 0...10 {
                print("...")
            }
        }
        queue.async {
            print("barrier - async3333: \(Thread.current)")
        }
        
        queue.async(group: nil, qos: .default, flags: .barrier) {
            print("barrier - async4444: \(Thread.current)")
        }

        print("============ Main: \(Thread.current)")
    }
}

