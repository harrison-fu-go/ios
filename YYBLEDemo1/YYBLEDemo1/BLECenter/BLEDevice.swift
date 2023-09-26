//
//  BLEDevice.swift
//  YYBLEDemo1
//
//  Created by fuhuayou on 2021/4/8.
//
import CoreBluetooth
import Foundation

class BLEDevice: NSObject {
    init(_ name: String?, _ uuid: String?, _ peripheral: CBPeripheral?) {
        self.name = name
        self.uuid = uuid
        self.blePeripheral = peripheral
    }
    
    var name: String?
    var uuid: String?
    var mac: String?
    var blePeripheral : CBPeripheral?
}
