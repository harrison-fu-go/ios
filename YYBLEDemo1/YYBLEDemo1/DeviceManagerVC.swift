//
//  DeviceManagerVC.swift
//  YYBLEDemo1
//
//  Created by fuhuayou on 2021/4/8.
//

import UIKit
import CoreBluetooth
class DeviceManagerVC: UIViewController, BLECenterProtocol {
    
    var bleCenter: BLECenter?
    var connectState = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.bleCenter!.connectedDevice?.name
        let rightBarButtonItem = UIBarButtonItem(title: "connected", style: UIBarButtonItem.Style.done, target: self, action: #selector(connectOrDisconnect));
        self.navigationItem.rightBarButtonItem = rightBarButtonItem;
        connectState = 1
        
        bleCenter?.delegates.add(delegate: self)
    }
    
    func onConnectStateDidUpdate(state: CBPeripheralState) {
        if state == .connected {
            DispatchQueue.main.async {
                self.navigationItem.rightBarButtonItem?.title = "connected"
                self.connectState = 1
            }
        } else {
            DispatchQueue.main.async {
                self.navigationItem.rightBarButtonItem?.title = "Disconnected"
                self.connectState = 0
            }
        }
    }
    
    
    @objc func connectOrDisconnect() {
        if connectState == 1 {
            bleCenter?.disconnect()
        } else {
            bleCenter?.connectDevice(device: self.bleCenter!.lastConnectedDevice!)
        }
    }
    
    @IBAction func click (_ sender : UIButton) {
//        let data = self.getBigData(count: 100)
//        bleCenter?.sendData("FFE0", "FFE1", data:data, type:.withoutResponse, callback: { (response:[String : Any]) in
//            print("=========== sendData response: ", response)
//        })
        
        let bytes = self.randomBytes(len: 10)
        bleCenter?.sendData("2600", "7000", bytes: bytes, type: .withoutResponse, callback: { response in
            print("=========== sendData response: ", response)
        })
    }
    
    @IBAction func readData (_ sender : UIButton) {
        bleCenter?.readData("FFE0", "FFE1", callback: { (response:[String : Any]) in
            print("=========== sendData response: ", response)
        })
    }
}

// 固件测试数据z
extension DeviceManagerVC {
    
    func getBigData(count: Int) -> Data {
        let mBytes: [UInt8]  =  [
            10, 10, 10, 0xa1, 0xa2, 33, 10, 0, 0, 0xa1, 0xa2, 33, 10, 0, 0, 0xa1, 0xa2, 33, 0xa2, 33,
            10, 10, 10, 0xa1, 0xa2, 33, 10, 0, 0, 0xa1, 0xa2, 33, 10, 0, 0, 0xa1, 0xa2, 33, 0xa2, 33,
            10, 10, 10, 0xa1, 0xa2, 33, 10, 0, 0, 0xa1, 0xa2, 33, 10, 0, 0, 0xa1, 0xa2, 33, 0xa2, 33,
            10, 10, 10, 0xa1, 0xa2, 33, 10, 0, 0, 0xa1, 0xa2, 33, 10, 0, 0, 0xa1, 0xa2, 33, 0xa2, 33,
            10, 10, 10, 0xa1, 0xa2, 33, 10, 0, 0, 0xa1, 0xa2, 33, 10, 0, 0, 0xa1, 0xa2, 33, 0xa2, 33,
            10, 10, 10, 0xa1, 0xa2, 33, 10, 0, 0, 0xa1, 0xa2, 33, 10, 0, 0, 0xa1, 0xa2, 33, 0xa2, 33,
            10, 10, 10, 0xa1, 0xa2, 33, 10, 0, 0, 0xa1, 0xa2, 33, 10, 0, 0, 0xa1, 0xa2, 33, 0xa2, 33,
            10, 10, 10, 0xa1, 0xa2, 33, 10, 0, 0, 0xa1, 0xa2, 33, 10, 0, 0, 0xa1, 0xa2, 33, 0xa2, 33,
            10, 10, 10, 0xa1, 0xa2, 33, 10, 0, 0, 0xa1, 0xa2, 33, 10, 0, 0, 0xa1, 0xa2, 33, 0xa2, 33,
            10, 10, 10, 0xa1, 0xa2, 33, 10, 0, 0, 0xa1, 0xa2, 33, 10, 0, 0, 0xa1, 0xa2, 0xff, 0xff, 0xff];
        let data: Data = Data(bytes: mBytes, count:count);
        return data
    }
    
    
    
    func bigDataTesting() {
        let mBytes: [UInt8]  =  [
            10, 10, 10, 0xa1, 0xa2, 33, 10, 0, 0, 0xa1, 0xa2, 33, 10, 0, 0, 0xa1, 0xa2, 33, 0xa2, 33,
            10, 10, 10, 0xa1, 0xa2, 33, 10, 0, 0, 0xa1, 0xa2, 33, 10, 0, 0, 0xa1, 0xa2, 33, 0xa2, 33,
            10, 10, 10, 0xa1, 0xa2, 33, 10, 0, 0, 0xa1, 0xa2, 33, 10, 0, 0, 0xa1, 0xa2, 33, 0xa2, 33,
            10, 10, 10, 0xa1, 0xa2, 33, 10, 0, 0, 0xa1, 0xa2, 33, 10, 0, 0, 0xa1, 0xa2, 33, 0xa2, 33,
            10, 10, 10, 0xa1, 0xa2, 33, 10, 0, 0, 0xa1, 0xa2, 33, 10, 0, 0, 0xa1, 0xa2, 33, 0xa2, 33,
            10, 10, 10, 0xa1, 0xa2, 33, 10, 0, 0, 0xa1, 0xa2, 33, 10, 0, 0, 0xa1, 0xa2, 33, 0xa2, 33,
            10, 10, 10, 0xa1, 0xa2, 33, 10, 0, 0, 0xa1, 0xa2, 33, 10, 0, 0, 0xa1, 0xa2, 33, 0xa2, 33,
            10, 10, 10, 0xa1, 0xa2, 33, 10, 0, 0, 0xa1, 0xa2, 33, 10, 0, 0, 0xa1, 0xa2, 33, 0xa2, 33,
            10, 10, 10, 0xa1, 0xa2, 33, 10, 0, 0, 0xa1, 0xa2, 33, 10, 0, 0, 0xa1, 0xa2, 33, 0xa2, 33,
            10, 10, 10, 0xa1, 0xa2, 33, 10, 0, 0, 0xa1, 0xa2, 33, 10, 0, 0, 0xa1, 0xa2, 0xff, 0xff, 0xff];
        let data: Data = Data(bytes: mBytes, count:mBytes.count);
        bleCenter?.sendData("6666", "7777", data: data)
    }
    
    func randomBytes(len: Int = 20) -> [UInt8] {
        var mBytes: [UInt8] = []
        for _ in 1...20 {
            mBytes.append(UInt8(arc4random() % 256))
        }
        return mBytes
    }
}
