//
//  BLEManager.swift
//  BLETools
//
//  Created by 钟城广 on 2020/12/8.
//

import Foundation
import CoreBluetooth
import Combine

typealias ScanCallback = (ExtendPeripheral) -> Void
typealias SyncProfileCallback = (CBPeripheral)-> Void
typealias ReadCallback = (CBCharacteristic, Data)->Void
class BLEManager: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate, ObservableObject {
    
    private var mCentralMgr: CBCentralManager!
    //扫描的缓存，暴露在外面使用的对象都能在这里找到
    var scanResultCache = [String: ExtendPeripheral]()
    
    // MARK: 单例
    private static let mgr:BLEManager = {
        let shared = BLEManager()
        return shared
    }()
    
    private override init(){
        super.init()
        // STEP 1: 为控制中心在后台创建一个并发队列
        let centralQueue: DispatchQueue = DispatchQueue(label: "com.bluexmicro.centralQueueName", attributes: .concurrent)
        // STEP 2: 创建用于扫描、连接、管理和从外围设备收集数据的控制中心。
        mCentralMgr = CBCentralManager(delegate: self, queue: centralQueue)
    }
    
    class func shared() ->BLEManager {
        return mgr
    }
    
    // MARK: 状态监听
    @Published var state: CBManagerState = .poweredOff
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        self.state = central.state
        switch central.state {
        case .poweredOff:
            print("蓝牙已关闭")
            break
        case .poweredOn:
            print("蓝牙已打开,请扫描外设")
            break
        case .resetting:
            print("正在重置状态")
            break
        case .unauthorized:
            print("无权使用蓝牙低功耗")
            break
        case .unknown:
            print("未知设备")
            break
        case .unsupported:
            print("此设备不支持BLE")
            break
        default: break
        }
    }
    
    // MARK: 扫描
    func isScanning() -> Bool{
        return mCentralMgr.isScanning
    }
    
    var scanCallback: ScanCallback?
    
    //
    // @Params: advServicesUUIDs
    //          当外设（Peripheral）的广播包中存在对应的servicesUuid才会被扫描到
    //
    func startScan(advServicesUUIDs uuids: [CBUUID]?,_ callback : @escaping ScanCallback) -> Bool {
        if mCentralMgr.isScanning {
            mCentralMgr.stopScan()
        }
        if self.state != .poweredOn { return false}
        //允许重复回调同一外设
        mCentralMgr.scanForPeripherals(withServices: uuids, options: [CBCentralManagerScanOptionAllowDuplicatesKey : true])
        scanCallback = callback
        return true
    }
    
    //
    // 扫描外设(peripheral)的回调
    //
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        let deviceUuid = peripheral.identifier.uuidString
        var exPeripheral = scanResultCache[deviceUuid]
        if(exPeripheral == nil){
            exPeripheral = ExtendPeripheral(peripheral: peripheral)
            scanResultCache.updateValue(exPeripheral!, forKey: deviceUuid)
        }
        exPeripheral!.update(advertisementData: advertisementData, RSSI: RSSI)
        scanCallback?(exPeripheral!)
    }
    
    func stopScan(){
        mCentralMgr.stopScan()
    }
    
    // MARK: 连接，断开以及连接状态的监听
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        let target: ExtendPeripheral? = scanResultCache[peripheral.identifier.uuidString]
        target?.updateState(state: .connected)
        print("\(peripheral.identifier.uuidString) 已连接")
    }
    
    // app断开连接
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        let target: ExtendPeripheral? = scanResultCache[peripheral.identifier.uuidString]
        target?.updateState(state: .disconnected)
        print("\(peripheral.identifier.uuidString) -> 连接已断开; reason \(String(describing: error?.localizedDescription))")
    }
    
    // 连接失败
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        let target: ExtendPeripheral? = scanResultCache[peripheral.identifier.uuidString]
        target?.updateState(state: .failed)
        print("\(peripheral.identifier.uuidString) -> 连接失败 reason \(String(describing: error?.localizedDescription))")
    }
    
    // 连接
    public func connect(target : ExtendPeripheral) -> Bool{
        target.updateState(state: .connecting)
        print("\(target.uuidString) 正在连接...")
        mCentralMgr.connect(target.mPeripheral, options: nil)
        //注册外设的代理
        target.mPeripheral.delegate = self
        return true
    }
    
    // 主动断开连接
    public func disconnect(exPeripheral device: ExtendPeripheral) {
        mCentralMgr.cancelPeripheralConnection(device.mPeripheral)
        //取消外设的代理
        device.mPeripheral.delegate = nil
    }
    
    // MARK: 同步服务特征
    private var syncCallback: SyncProfileCallback?
    public func syncProfile(target peripheral: CBPeripheral,callback syncCallback:@escaping SyncProfileCallback){
        self.syncCallback = syncCallback
        //发现外设的所有服务
        peripheral.discoverServices(nil)
    }
    
    var currentPeripheral:ExtendPeripheral?
    
    private var discoverServiceTasks = [String : Int]()
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if peripheral.services != nil {
            //记录将会有多少次回调
            discoverServiceTasks.updateValue(peripheral.services!.count, forKey: peripheral.identifier.uuidString)
            // 遍历该服务的所有特征
            for service in peripheral.services!{
                peripheral.discoverCharacteristics(nil, for: service)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        discoverDescriptors(service: service)
        let key = peripheral.identifier.uuidString
        let task: Int? = discoverServiceTasks[key]
        if task != nil {
            let remainTime = task! - 1
            discoverServiceTasks.updateValue(remainTime, forKey: key)
            if(remainTime <= 0){
                self.syncCallback?(peripheral)
                discoverServiceTasks.removeValue(forKey: key)
            }
        }
    }
    
    private func discoverDescriptors(service: CBService){
        service.characteristics?.forEach({ (chara) in
            if chara.properties.contains(.indicate) || chara.properties.contains(.notify) {
                service.peripheral.discoverDescriptors(for: chara)
            }
        })
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverDescriptorsFor characteristic: CBCharacteristic, error: Error?) {
        //nothing to do
    }
    
    // MARK: Read Write Indicat Notify
    var remotePeripheralDelegate: RemotePeripherlDelegate?
    
    //onRead indicate notify
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        remotePeripheralDelegate?.onReceived(remote: peripheral, characteristic: characteristic, error: error)
    }
    //onWrite
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        remotePeripheralDelegate?.onWrite(remote: peripheral, characteristic: characteristic, error: error)
    }
    //indicate or notify
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        print("didUpdateNotificationStateFor:\(characteristic.isNotifying)")
    }
    
 
    func read(characteristic:CBCharacteristic){
        characteristic.service.peripheral
            .readValue(for: characteristic)
    }
    
    func write(data :Data, characteristic:CBCharacteristic, type: CBCharacteristicWriteType){
        characteristic.service.peripheral
            .writeValue(data, for: characteristic, type: type)
    }
    
    //notify or indicate
    func notify(characteristic:CBCharacteristic) {
        characteristic.service.peripheral
            .setNotifyValue(!characteristic.isNotifying, for: characteristic)
    }
    
    // MARK: 自动分包发送长数据
    //目前只支持20个字节
    var busy = false
    var bigDataCharacteristic:CBCharacteristic? = nil
    var bigDataTasks = [Data]()
    func WrtieBigData(data: Data, characteristic: CBCharacteristic){
        self.bigDataCharacteristic = characteristic
        if data.count > 20 {
            for i in stride(from: 0, to: data.count, by: 20){
                let remain = data.count - i
                let len = remain <= 20 ? remain : 20
                let range = i ..< (len + i)
                let segment = data[range]
                bigDataTasks.append(segment)
            }
        }else{
            bigDataTasks.append(data)
        }
        write(data: bigDataTasks.remove(at: 0), characteristic: characteristic, type: .withoutResponse)
    }
    
    //这个变量在发送连续任务时，尤为重要，如果发送的过快会导致外设假死等预料之外的错误
    func peripheralIsReady(toSendWriteWithoutResponse peripheral: CBPeripheral) {
        self.busy = !peripheral.canSendWriteWithoutResponse
//        print("busy:\(busy)")
        //当满足一下条件，发送分包数据
        if !busy && bigDataCharacteristic != nil {
            if bigDataTasks.isEmpty {
                self.remotePeripheralDelegate?.onBigDataSent()
                self.bigDataCharacteristic = nil
            }else{
                let cmd = bigDataTasks.remove(at: 0)
//                print(cmd.toHexString())
                write(data: cmd, characteristic: bigDataCharacteristic!, type: .withoutResponse)
            }
        }
    }
    
    
}
