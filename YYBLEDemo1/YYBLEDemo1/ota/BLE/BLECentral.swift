//
//  BLECentral.swift
//  BLETools
//
//  Created by 钟城广 on 2020/11/24.
//

import Foundation
import CoreBluetooth

typealias ScanResultCallback = (CBPeripheral, [String : Any],  NSNumber) -> Void
typealias StateCallback = (CBManagerState) -> Void

class BLECentral: NSObject, CBCentralManagerDelegate {
    
    var state: CBManagerState = .poweredOff
    //对连接的外设进行缓存
    var connectionCache = [String: ExtendPeripheral]()
    
    private lazy var mCentralMgr : CBCentralManager = {
        // STEP 1: 为控制中心在后台创建一个并发队列
        let centralQueue: DispatchQueue = DispatchQueue(label: "com.bluexmicro.centralQueueName", attributes: .concurrent)
        // STEP 2: 创建用于扫描、连接、管理和从外围设备收集数据的控制中心。
        let mgr = CBCentralManager(delegate: self, queue: centralQueue)
        hasInit = true
        return mgr
    }()
    
    private var hasInit = false
    
    // 蓝牙状态初始化和更新时回调
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        //这里是子线程
        self.state = central.state
        //callback
        for callback in stateCallbacks{
            callback(self.state)
        }
    }
    
    func isScanning() -> Bool{
      return  mCentralMgr.isScanning
    }
    
    
    var scanResultCallback: ScanResultCallback?
    //
    // @Params: advServicesUUIDs
    //          当外设（Peripheral）的广播包中存在对应的servicesUuid才会被扫描到
    //
    func scanPeripheral(advServicesUUIDs uuids: [CBUUID]?,callback : @escaping ScanResultCallback) -> Bool{
        if mCentralMgr.isScanning {
            mCentralMgr.stopScan()
        }
        if self.state != .poweredOn { return false}
        mCentralMgr.scanForPeripherals(withServices: uuids, options: [CBCentralManagerScanOptionAllowDuplicatesKey : true])
        print("isScanning: \(mCentralMgr.isScanning)")
        scanResultCallback = callback
        return true
    }
    
    func stopScan(){
        if mCentralMgr.isScanning {
            mCentralMgr.stopScan()
        }
    }
    
    //
    // 扫描外设(peripheral)的回调
    //
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        scanResultCallback?(peripheral, advertisementData , RSSI)
    }
    
    //
    // 已连接
    //
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        let target: ExtendPeripheral? = connectionCache[peripheral.identifier.uuidString]
        target?.updateState(state: .connected)
        print("\(peripheral.identifier.uuidString) 已连接")
    }
    
    //
    // app断开连接
    //
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        let target: ExtendPeripheral? = connectionCache[peripheral.identifier.uuidString]
        target?.updateState(state: .disconnected)
        print("\(peripheral.identifier.uuidString) -> 连接已断开; reason \(String(describing: error?.localizedDescription))")
    }
    
    //
    // 连接失败
    //
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        let target: ExtendPeripheral? = connectionCache[peripheral.identifier.uuidString]
        target?.updateState(state: .failed)
        print("\(peripheral.identifier.uuidString) -> 连接失败 reason \(String(describing: error?.localizedDescription))")
    }
    
    // 连接
    public func connect(target : ExtendPeripheral) -> Bool{
        connectionCache.updateValue(target, forKey: target.uuidString)
        target.updateState(state: .connecting)
        print("\(target.uuidString) 正在连接...")
        mCentralMgr.connect(target.mPeripheral, options: nil)
        return true
    }
    
    // 主动断开连接
    public func disconnect(peripheral device: CBPeripheral) {
        mCentralMgr.cancelPeripheralConnection(device)
    }
    
    //
    // stateCallback
    //
   
    private var stateCallbacks = [StateCallback]()
    
    func addOnStateChangedCallback(callback:@escaping StateCallback){
        if !hasInit {print("isScanning: \(mCentralMgr.isScanning)")} //其实就是为了初始化lazy
        self.stateCallbacks.append(callback)
    }
    
    func removeStateChangedCallback(callback:@escaping StateCallback){
        let index = self.stateCallbacks.firstIndex { (state) -> Bool in
            return true
        }
        if index == nil {return}
        stateCallbacks.remove(at: index!)
    }
}

