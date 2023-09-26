//
//  GCD.swift
//  YYSwiftLearning
//
//  Created by zk-fuhuayou on 2021/9/8.
//

import UIKit

class GCD: NSObject {
    
    func testing() {
//        testing_sync()
//        return ;
        //DispatchQueue, 和 DispatchGroup的使用。.... 
        DispatchQueue.global().async {
            let group = DispatchGroup()
            let queue0 = DispatchQueue(label:"queue0", attributes: .concurrent)
            queue0.async(group: group) {
                Thread.sleep(forTimeInterval: 1.0)
                print("=====async queue0, \(Date().description)")
                DispatchQueue.global().asyncAfter(deadline: .now() + 15.0) {
                    print("=====DispatchQueue.global(), \(Date().description)")
                }
            }

            let queue1 = DispatchQueue(label:"queue1", attributes: .concurrent)
            queue1.async(group: group) {
                Thread.sleep(forTimeInterval: 2.0)
                print("=====async queue1, \(Date().description)")
            }

            let queue2 = DispatchQueue(label:"queue2", attributes: .concurrent)
            queue2.async(group: group) {
                print("=====async queue2, \(Date().description)")
                Thread.sleep(forTimeInterval: 4.0)
            }

            print("=====async wait, \(Date().description)")
            group.wait()
            print("=====async wait done., \(Date().description)")
        }
    }
    
    //multiple tasks, and sync. 多任务异步同步。 
    func testing_sync() {
        DispatchQueue.global().async {
            let group = DispatchGroup()
            let queue0 = DispatchQueue(label:"queue0", attributes: .concurrent)
            
            group.enter()
            queue0.async {
                Thread.sleep(forTimeInterval: 4.0)
                print("=====async=======0, \(Date().description)")
                group.leave()
            }
            
            group.enter()
            queue0.async {
                Thread.sleep(forTimeInterval: 2.0)
                print("=====async=======1, \(Date().description)")
                group.leave()
            }
            
            group.enter()
            queue0.async {
                DispatchQueue.global().asyncAfter(deadline: .now() + 8.0) {
                    print("=====DispatchQueue.global(), \(Date().description)")
                    group.leave()
                }
            }
            
            group.wait()
            print("=====group done, \(Date().description)")
        }
    }
    
    
}
