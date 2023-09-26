//
//  AnyExtension.swift
//  iGlasses
//
//  Created by zk-fuhuayou on 2021/5/19.
//

import Foundation
//swiftlint:disable force_unwrapping
public func zk_strKeyValues(of obj: Any) -> [String:String] {
    var result = [String:String]()
    let m = Mirror(reflecting: obj)
    let properties = Array(m.children)
    for k in properties {
        if let value = (k.value as? String) {
            result[k.label!] = value
        }
        
        if let value = (k.value as? Int) {
            result[k.label!] = String(value)
        }
        
        if let value = (k.value as? Int8) {
            result[k.label!] = String(value)
        }
        
        if let value = (k.value as? Int16) {
            result[k.label!] = String(value)
        }
        
        if let value = (k.value as? Int64) {
            result[k.label!] = String(value)
        }
        
        if let value = (k.value as? Double) {
            result[k.label!] = String(value)
        }
    }
    return result
}
