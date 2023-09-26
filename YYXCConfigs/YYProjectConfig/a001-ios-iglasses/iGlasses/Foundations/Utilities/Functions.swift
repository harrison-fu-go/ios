//
//  File.swift
//  iGlasses
//
//  Created by Matthew on 2021/4/13.
//

import Foundation

func configure<T: AnyObject>(_ object: T, closure: (T) -> Void) -> T {
    closure(object)
    return object
}

func dispatch_later(_ time: TimeInterval, block: @escaping () -> Void) {
    let t = DispatchTime.now() + time
    DispatchQueue.main.asyncAfter(deadline: t, execute: block)
}
