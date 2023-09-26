//
//  BLECenterProtocol.swift
//  YYBLEDemo1
//
//  Created by zk-fuhuayou on 2021/5/8.
//

import Foundation
import CoreBluetooth
//swiftlint:disable attributes
@objc enum BLEConnState : Int {
    case searching = -1
    case connecting = 0
    case connected = 1
    case disconnecting = 2
    case disconnected = 3
}

//swiftlint:disable attributes
@objc protocol BLECenterProtocol {
    
    //power state.
    @objc optional func onPowerStateDidUpdate(state: CBManagerState)
    
    //scan state.
    @objc optional func onScanStateDidUpdate(isScan: Bool)
    @objc optional func onScanDevicesListUpdate(devices:[BLEDevice])
    
    //connect state
    @objc optional func onConnectStateDidUpdate(state: BLEConnState)
    
    //on update value for characteristic.
    @objc optional func onUpdateCharacteristicValue(cha: CBCharacteristic, error: Error?)
    
    //on write value for characteristic.
    @objc optional func onWriteCharacteristicValue(cha: CBCharacteristic, error: Error?)
    
    @objc optional func onIsReadyToSendWriteWithoutResponse(peripheral: CBPeripheral)
    

}
 
