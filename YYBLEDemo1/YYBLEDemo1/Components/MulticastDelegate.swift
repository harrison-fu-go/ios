//
//  MulticastDelegate.swift
//  YYBLEDemo1
//
//  Created by zk-fuhuayou on 2021/5/8.
//

import UIKit
//swiftlint:disable void_return force_cast static_operator
class MulticastDelegate <T> {
    private let delegates: NSHashTable<AnyObject> = NSHashTable.weakObjects()
    
    func add(delegate: T, queue:DispatchQueue = DispatchQueue.global()) {
        delegates.add(delegate as AnyObject)
    }
    
    func remove(delegate: T) {
        for oneDelegate in delegates.allObjects.reversed() where oneDelegate === delegate as AnyObject {
            delegates.remove(oneDelegate)
        }
    }
    
    func `do`(invocation: (T) -> ()) {
        for delegate in delegates.allObjects.reversed() {
            invocation(delegate as! T)
        }
    }
}

func += <T: AnyObject> (left: MulticastDelegate<T>, right: T) {
    left.add(delegate: right)
}

func -= <T: AnyObject> (left: MulticastDelegate<T>, right: T) {
    left.remove(delegate: right)
}
