//
//  DatabaseModel.swift
//  iGlasses
//
//  Created by zk-fuhuayou on 2021/5/14.
//

import UIKit

//swiftlint:disable force_cast force_unwrapping
class DatabaseModel: NSObject {
    
    func setAssociateValues(values: [[String: String]]) {
        for value in values {
            let key = value["key"]
            let value = value["value"]
            self.setAssociateValue(key: key!, value: value)
        }
    }
    
    func associateCopy(valMap:[String:String]) {
        for (key, value) in valMap {
            self.setAssociateValue(key: key, value: value)
        }
    }
    
    func setAssociateValue(key:String, value: String?) {
        let valueType: objc_AssociationPolicy = .OBJC_ASSOCIATION_RETAIN_NONATOMIC
        let iKey: UnsafeRawPointer! = UnsafeRawPointer(bitPattern: key.hashValue)
        let valStr = value?.base64Encoding()
        objc_setAssociatedObject(self, iKey, valStr, valueType)
    }
    
    func associateValue(key:String) -> String? {
        let iKey: UnsafeRawPointer! = UnsafeRawPointer(bitPattern: key.hashValue)
        let value = objc_getAssociatedObject(self, iKey)
        if value == nil {
            return nil
        }
        let valueStr = String(value as! String).base64Decoding()
        return valueStr
    }
    
    func printAll(reflect: [String]) {
        var str = "====== "
        for key in reflect {
            str += (key + ":" + (self.associateValue(key: key) ?? "nil") + "----")
        }
        print(str)
    }
    
    static func copyModel(obj: Any) -> DatabaseModel {
        let valMap = zk_strKeyValues(of: obj)
        let taskModel = DatabaseModel()
        taskModel.associateCopy(valMap: valMap)
        return taskModel
    }
    
}
