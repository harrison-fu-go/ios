//
//  OtaManager.swift
//  iGlasses
//
//  Created by zk-fuhuayou on 2021/8/6.
//

import UIKit
import CoreBluetooth
class OtaManager: NSObject {
    var progressCallbcak: BLECALLBACK?
    var filePath: String?
    var otaVM: OtaViewModel?
    func otaStart(_ filePath:String, _ progressCallback:BLECALLBACK?, _ callback: BLECALLBACK?) {
        self.filePath = Bundle.main.path(forResource: "template_ota", ofType: "bin")
//        self.filePath = filePath
        self.progressCallbcak = callback
        
        guard let filePath = self.filePath else {
            callback?(["response": ProgressHandle(state: .error, message: "file path nil.", error: NSError.error(messge: "file path nil."))])
            return
        }
        
        let characteristics = BLEManager.ble().connServices?[BLEConstants.OTA_SERVER] ?? []
        guard let characteristics = (characteristics.isEmpty ? nil : characteristics)  else {
            callback?(["response": ProgressHandle(state: .error, message: "no service", error: NSError.error(messge: "no service"))])
            return
        }
        
        otaVM = OtaViewModel()
        otaVM?.start(service: characteristics[0].service, path: filePath, progressCallback:progressCallback, otaCallback: callback)
    }
 
}
