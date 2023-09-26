//
//  BLEManager.swift
//  iGlasses
//
//  Created by zk-fuhuayou on 2021/8/3.
//

import UIKit

//swiftlint:disable force_unwrapping
class BLEManager: NSObject {
    
    static let manager = BLEManager()
    var bles:[String:BLECenter] = [:]
    static func ble(identifier:String = "holoever.bluetooth.BLEIDENTIFIER") -> BLECenter {
        var ble = manager.bles[identifier]
        if ble == nil {
            ble = BLECenter(identifier)
            manager.bles[identifier] = ble
        }
        return ble!
    }

}
