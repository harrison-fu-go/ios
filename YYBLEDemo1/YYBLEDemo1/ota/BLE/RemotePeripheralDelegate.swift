//
//  RemotePeripheralDelegate.swift
//  BLETools
//
//  Created by 钟城广 on 2020/12/11.
//

import Foundation
import CoreBluetooth

protocol RemotePeripherlDelegate {
    
    //read ,indicate or write
    func onReceived(remote:CBPeripheral,characteristic: CBCharacteristic,error:Error?)-> Void
    
    func onWrite(remote:CBPeripheral,characteristic: CBCharacteristic,error:Error?)-> Void
    
    func onBigDataSent() -> Void
    
}
