//
//  YYPeripheralCenter.swift
//  YYIOSPeripheral
//
//  Created by zk-fuhuayou on 2021/5/27.
//

import UIKit
import CoreBluetooth
class YYPeripheralCenter: NSObject, CBPeripheralManagerDelegate {
     
    let queue = DispatchQueue(label: "YYPeripheralCenter.peripheral.queue")
    var peripheralManager: CBPeripheralManager?
    
    //uuids.
    // UUID for the one peripheral service, declared outside the class:
    var peripheralServiceUUID = CBUUID(string: "9BC1F0DC-F4CB-4159-BD38-7375CD0DD545")
    // UUID for one characteristic of the service above, declared outside the class:
    var nameCharacteristicUUID = CBUUID(string: "9BC1F0DC-F4CB-4159-BD38-7B74CD0CD546")
    
    override init() {
        super.init()
        peripheralManager = CBPeripheralManager(delegate: self, queue: queue, options: nil)
    }
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        print("==================== peripheral: ", peripheral.state.rawValue)
    }
    
    func startBroadCast()  {
        guard let manager = self.peripheralManager else{
            return
        }
        manager.add(CBMutableService(type: peripheralServiceUUID, primary: true))
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didAdd service: CBService, error: Error?) {
        if (error != nil) {
            print("PerformerUtility.publishServices() returned error: \(error!.localizedDescription)")
        } else {
            print("==================== 开启广播")
            peripheralManager?.startAdvertising([CBAdvertisementDataServiceUUIDsKey : [service.uuid],
                                                 CBAdvertisementDataLocalNameKey : "YY_Peripheral_1"])
        }
    }
    
    
    func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?) {
        
    }
    
    
    
}
