//
//  ArrayExtension.swift
//  iGlasses
//
//  Created by zk-fuhuayou on 2021/5/24.
//

import Foundation

extension Array {
    func containsObjects(objects: [Any]) -> Bool {
        var isContains = true
        for obj in objects {
            isContains = self.contains { zk_isEqual(a: $0, b: obj) }
        }
        return isContains
    }
}
