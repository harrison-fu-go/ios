//
//  AnyExtension.swift
//  iGlasses
//
//  Created by zk-fuhuayou on 2021/5/19.
//

import Foundation
//swiftlint:disable force_unwrapping force_cast
public func zk_strKeyValues(of obj: Any) -> [String:String] {
    var result = [String:String]()
    let m = Mirror(reflecting: obj)
    let properties = Array(m.children)
    for k in properties {
        if let value = String.zk_string(val: k.value) {
            result[k.label!] = value
        }
    }
    return result
}


public func zk_isEqual(a: Any, b: Any) -> Bool {
    let typeA = type(of: a)
    let typeB = type(of: b)
    if typeA != typeB {
        return false
    }
    
    if let a = (a as? NSNumber) {
        return a.isEqual(to: (b as! NSNumber))
    }
    
    if let a = (a as? String) {
        return a == (b as! String)
    }
    
    let isEqual = (a as AnyObject).isEqual?(b) ?? false
    return isEqual
}
