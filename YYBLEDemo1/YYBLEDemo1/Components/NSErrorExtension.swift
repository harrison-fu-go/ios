//
//  NSErrorExtension.swift
//  iGlasses
//
//  Created by zk-fuhuayou on 2021/5/31.
//

import Foundation


extension NSError {
    static func error(code:Int = 10000, messge: String) -> NSError {
        let error = NSError(domain: "holoever.custom.error", code: code, userInfo: [NSLocalizedDescriptionKey: messge])
        return error
    }
}
