//
//  StringExtension.swift
//  iGlasses
//
//  Created by zk-fuhuayou on 2021/5/20.
//

import Foundation
extension String {
    static func zk_string<T>(val:T) -> String? {
        if let val = val as? String {
            return val
        }
        if let val = val as? NSNumber {
            let result = String(val.int64Value)
            return result
        }
        return nil
    }
    

    mutating func remove(char: Character) -> String {
       var chars = Array(self)
        var index = -1
        for iindex in 0 ..< chars.count {
            let iichar = chars[iindex]
            if iichar == char {
                index = iindex
                break
            }
        }
        if index != -1 {
            chars.remove(at: index)
        }
        self = String(chars)
        return self
    }
    
    func remove(members: Character...) -> String {
        var temStr = self
        for i in members {
            temStr = temStr.remove(char: i)
        }
        return temStr
    }
}
