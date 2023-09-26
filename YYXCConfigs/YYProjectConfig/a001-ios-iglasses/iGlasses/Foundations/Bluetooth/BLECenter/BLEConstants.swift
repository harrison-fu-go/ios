//
//  BLEConstants.swift
//  YYBLEDemo1
//
//  Created by zk-fuhuayou on 2021/5/8.
//
//swiftlint:disable type_name prefixed_toplevel_constant
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
    static let BLE_SCAN_SERVICE = "SCAN_SERVICES"
    static let DEVICE = "DEVICE"
    //callback key.
    static let STATE = "state"
    static let MESSAGE = "message"
    static let VALUE = "value"
    
    //connected device.
    static let BLE_LAST_CONNECTED = "BLE_LAST_CONNECTED"
    
    //OTA
    static let OTA_SERVER = "2600"
    static let OTA_CHARACTERISTIC0 = "7000"
    static let OTA_CHARACTERISTIC1 = "7001"
}

let BLE_DEBUG = 1

struct BLE_DEMO_DEVICE {
    static let NAME = "zk-ancs"
    static let SERVICES = ["2600"]
    static let SCAN_SERVICES:String? = nil
//    static let NAME = "BX-ios5" //"zk-ancs" BX-ios5 BX-and9
//    static let SERVICES = ["180A", "2600", "00006666-D102-E111-9B23-00025B00A5C7"] //, "2600", "00006666-D102-E111-9B23-00025B00A5C7"
//    static let SCAN_SERVICES:String? = "00001812-0000-1000-8000-00805f9b34fb"
}

struct BLE_CONFIG {
    static func scanService() -> String? {
        return BLE_DEBUG != 1 ? nil : BLE_DEMO_DEVICE.SCAN_SERVICES
    }
    
    static func services() -> [String] {
        return BLE_DEBUG != 1 ? [] : BLE_DEMO_DEVICE.SERVICES
    }
    
    static func name() -> String? {
        return BLE_DEBUG != 1 ? nil : BLE_DEMO_DEVICE.NAME
    }
}
