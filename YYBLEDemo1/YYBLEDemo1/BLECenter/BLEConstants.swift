//
//  BLEConstants.swift
//  YYBLEDemo1
//
//  Created by zk-fuhuayou on 2021/5/8.
//

import Foundation

typealias BLECALLBACK = ([String: Any]) -> Void

struct BLEConstants {
    static let SERVICE_UUID = "SERVICE_UUID"
    static let SERVICE_UUIDS = "SERVICE_UUIDS"
    static let CHARACTERISTIC_UUID = "CHARACTETRISTIC_UUID"
    static let BLE_DEVICE_UUID = "DEVICE_UUID"
    static let BLE_DEVICE_NAME = "DEVICE_NAME"
    static let BLE_TIMEOUT = "TIMEOUT"
    static let BLE_IS_DISCONNECTED_MANUAL = "IS_DISCONNECTED_MANUAL"

    static let DEVICE = "DEVICE"
    //callback key.
    static let STATE = "state"
    static let MESSAGE = "message"
    static let VALUE = "value"
    
    //connected device.
    static let BLE_LAST_CONNECTED = "BLE_LAST_CONNECTED"
}
