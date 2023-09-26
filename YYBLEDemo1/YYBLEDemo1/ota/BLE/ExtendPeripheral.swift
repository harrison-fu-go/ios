//
//  ExtendPeripheral.swift
//  BLETools
//
//  Created by 钟城广 on 2020/11/24.
//

import Foundation
import CoreBluetooth
import SwiftUI

class ExtendPeripheral :NSObject, ObservableObject{
    
    let uuidString: String
    var mPeripheral : CBPeripheral
    public private(set) var advData = [String : Any]()
    private var rssi: NSNumber = -127
    
    @Published var mRssi:Int = -127
    @Published var state: ConnectionState = ConnectionState.idle
    
    func updateState(state: ConnectionState){
        DispatchQueue.main.async {
            self.state = state
        }
    }
    
    //
    // adv data
    //
    public private(set) var localName:String?
    public private(set) var isConnectable :Bool = false
    public private(set) var meshType = MeshType.Other
    public private(set) var mac: String?
    //广播服务
    public private(set) var advertisedServices  : [CBUUID]?
    
    init(peripheral : CBPeripheral) {
        self.uuidString = peripheral.identifier.uuidString
        self.mPeripheral = peripheral
    }
    
    func update(advertisementData advData:[String : Any], RSSI rssi: NSNumber)  {
        self.advData = advData
        self.rssi = rssi
        self.isConnectable = advData["kCBAdvDataIsConnectable"] as? NSNumber == 1
        self.localName = advData["kCBAdvDataLocalName"] as? String
        
        if let services = advData[CBAdvertisementDataServiceUUIDsKey] as? [CBUUID] {
            advertisedServices = services
        } else {
            advertisedServices = nil
        }
        //        parseMAC()
    }
    
    func notifyUI() {
        self.mRssi = self.rssi.intValue
    }
    
    private func parseMAC(){
        //kCBAdvDataManufacturerData
        //{length = 29, bytes = 0x0600010f 200230e9 67e43f26 0fae3233 ... 9c133719 689ebb88 }
        let manufacturerData = advData["kCBAdvDataManufacturerData"] as? Data
        if manufacturerData != nil && manufacturerData!.count >= 6 {
            let mRange: NSRange = NSRange.init(location: 0 ,length: 6)
            let range :Range<Data.Index> = Range.init(mRange)!
            let macData = manufacturerData?.subdata(in: range)
            if macData != nil {
                mac =  macData!.compactMap {
                    String(format: "%02x", $0).uppercased()
                }.joined(separator: ":")
            }
        }
    }
}
