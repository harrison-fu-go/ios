//
//  OtaViewModel.swift
//  BLETools
//
//  Created by zk-fuhuayou on 2021/8/6.
//

import Foundation
import CoreBluetooth
//swiftlint:disable force_unwrapping redundant_optional_initialization opening_brace explicit_init
class OtaViewModel :ObservableObject {
    
    var ctrlCharacteristic: CBCharacteristic? = nil
    var dataCharacteristic: CBCharacteristic? = nil
//    @Published var paths = [String]()
    @Published var isUpdating = false
    @Published var logs = [BLELog]()
    var task: OtaTask? = nil
    let stateHelper = OtaStateHelper()
    
    //big data.
    var busy = false
    var bigDataCharacteristic:CBCharacteristic? = nil
    var bigDataTasks = [Data]()
    
    //send data length
    var didSendLength = 0
    var otaCallback: BLECALLBACK?
    var progressCallback: BLECALLBACK?
    
    init() {
        BLEManager.ble().delegates.add(delegate: self)
//        self.paths = Bundle.main.paths(forResourcesOfType: "bin", inDirectory: nil)
        stateHelper.otaStateMachine.add(state: .IDLE) {
            print("IDLE; last: \(String(describing: self.stateHelper.otaStateMachine.lastTransition))")
        }
        stateHelper.otaStateMachine.add(state: .PREPARE) {
            self.setUpdate(aBool: true)
            print("PREPARE")
            self.prepare()
        }
        stateHelper.otaStateMachine.add(state: .START_OTA) {
            self.setUpdate(aBool: true)
            print("START_OTA")
            self.requestOtaStart()
        }
        stateHelper.otaStateMachine.add(state: .NEXT_BLOCK) {
            self.setUpdate(aBool: true)
            print("NEXT_BLOCK")
            self.requestNextBlock()
        }
        stateHelper.otaStateMachine.add(state: .TRANSFER_SEGMENT) {
            self.setUpdate(aBool: true)
            print("TRANSFER_SEGMENT")
            self.transferSegment()
        }
        stateHelper.otaStateMachine.add(state: .CHECK_ACK){
            self.setUpdate(aBool: true)
            print("CHECK_ACK")
            self.readAck()
        }
        stateHelper.otaStateMachine.add(state: .FINISH) {
            self.setUpdate(aBool: false)
            print("FINISH")
            self.allDataSent()
            self.otaCallback?(["response": ProgressHandle(state: .complete, message: "complete", error: nil)])
        }
        stateHelper.otaStateMachine.add(state: .FAILED) {
            self.setUpdate(aBool: false)
            self.otaCallback?(["response": ProgressHandle(state: .error, message: "error", error: nil)])
        }
        stateHelper.otaStateMachine.initialState = .IDLE
    }
    
    
    private func setUpdate(aBool:Bool){
        if isUpdating != aBool {
            DispatchQueue.main.async {
                self.isUpdating = aBool
            }
        }
    }
    
    func start(service:CBService?, path:String, progressCallback:BLECALLBACK?, otaCallback: BLECALLBACK?) {
        self.mService = service
        self.mPath = path
        self.otaCallback = otaCallback
        self.progressCallback = progressCallback
        //idle > Start
        stateHelper.otaStateMachine.fire(transition: .Confiing)
        setUpdate(aBool: true)
    }
    
    // MARK: 操作
    private var mService: CBService? = nil
    private var mPath:String? = nil
    // Step 1 准备数据，并开启Indicate
    private func prepare() {
        var log = BLELog(desc: "OTA: Data preparation")
        if mPath == nil || mService == nil {
            log.error = "Invalid Data"
            postLog(log)
            stateHelper.otaStateMachine.fire(transition: .ERROR)
            return
        }
        task = OtaTask(path: mPath!)
        mService!.characteristics?.forEach({ characteristic in
            if characteristic.uuid.uuidString.contains("7000") {
                ctrlCharacteristic = characteristic
            }
            if characteristic.uuid.uuidString.contains("7001") {
                dataCharacteristic = characteristic
            }
        })
        if ctrlCharacteristic == nil || dataCharacteristic == nil {
            log.error = "No Match service"
            postLog(log)
            stateHelper.otaStateMachine.fire(transition: .ERROR)
            return
        }
        BLEManager.ble().notify(characteristic: ctrlCharacteristic!, value:true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            if self.ctrlCharacteristic?.isNotifying == true {
                self.stateHelper.otaStateMachine.fire(transition: .START)
            } else {
                var log = BLELog(desc: "OTA: Data preparation")
                log.error = "Indicate open exception"
                self.postLog(log)
                self.stateHelper.otaStateMachine.fire(transition: .ERROR)
            }
        }
    }
    
    private  func requestOtaStart(){
        var log = BLELog(desc: "Request to start OTA")
        guard let cmd = task?.startPkt() else {
            log.error = "Invalid data"
            stateHelper.otaStateMachine.fire(transition: .ERROR)
            postLog(log)
            return
        }
        if self.ctrlCharacteristic == nil {
            log.error = "No Match Characteristic"
            stateHelper.otaStateMachine.fire(transition: .ERROR)
            postLog(log)
            return
        }
        
        BLEManager.ble().iOtaWrite(data: cmd, characteristic: self.ctrlCharacteristic!, type:.withResponse)
        log.data = cmd
        postLog(log)
    }
    
    private func requestNextBlock(){
        var log = BLELog(desc: "Request to write a new block")
        if self.ctrlCharacteristic == nil {
            log.error = "No Match Characteristic"
            postLog(log)
            stateHelper.otaStateMachine.fire(transition: .ERROR)
            return
        }
        guard let cmd = task?.loadNextBlockPacket() else {
            stateHelper.otaStateMachine.fire(transition: .DONE)
            return
        }
        BLEManager.ble().iOtaWrite(data: cmd, characteristic: ctrlCharacteristic!, type: .withResponse)
        log.data = cmd
        postLog(log)
    }
    
    private func transferSegment() {
        var log = BLELog(desc: "Writes all segments of the block")
        if self.dataCharacteristic == nil {
            log.error = "No Match Characteristic"
            postLog(log)
            stateHelper.otaStateMachine.fire(transition: .ERROR)
            return
        }
        guard let data = task?.loadAllDataOfBlock() else {
            log.error = "Invalid data"
            postLog(log)
            return
        }
        self.WrtieBigData(data: data, characteristic: dataCharacteristic!)
        log.data = data
        postLog(log)
    }
    
    private func readAck(){
        var log = BLELog(desc: "Read ACK")
        if self.dataCharacteristic == nil {
            log.error = "No Match Characteristic"
            postLog(log)
            stateHelper.otaStateMachine.fire(transition: .ERROR)
            return
        }
        BLEManager.ble().iOtaRead(characteristic: dataCharacteristic!)
        postLog(log)
    }
    
    private func allDataSent(){
        var log = BLELog(desc: "All data is transferred")
        if self.ctrlCharacteristic == nil {
            log.error = "No Match Characteristic"
            postLog(log)
            stateHelper.otaStateMachine.fire(transition: .ERROR)
            return
        }
        let cmd = Data.init([3])
        BLEManager.ble().iOtaWrite(data: cmd, characteristic: ctrlCharacteristic!, type: .withResponse)
        log.data = cmd
        postLog(log)
    }
    
    private func postLog(_ log:BLELog) {
        DispatchQueue.main.async {
            self.logs.append(log)
        }
    }
    
    deinit {
        print("======== OtaViewModel deinit =======")
    }
}

extension OtaViewModel: BLECenterProtocol {
    
    func onUpdateCharacteristicValue(cha: CBCharacteristic, error:Error?) {
        if error != nil {
            var log = BLELog(desc: "OnReceived")
            log.error = String(describing: error)
            self.postLog(log)
            stateHelper.otaStateMachine.fire(transition: .ERROR)
            return
        }
        guard let value = cha.value else {
            return
        }
        //read ack
        if cha == dataCharacteristic {
            var log = BLELog(desc: "Received ACK")
            log.data = value
            self.postLog(log)
            let needResend = task?.needResendSegments(ack: value) ?? false
            if needResend {
                stateHelper.otaStateMachine.fire(transition: .RESEND)
            } else {
                stateHelper.otaStateMachine.fire(transition: .RECEIVED)
            }
        }
        if cha == ctrlCharacteristic {
            var log = BLELog(desc: "Received Indicate")
            log.data = value
            self.postLog(log)
            if value[0] == 1 && value[1] == 0 {
                task?.setup(maxSegmentNumInBlock: Int(value[2]) * 8)
                stateHelper.otaStateMachine.fire(transition: .RECEIVED)
            }
        }
    }
    
    //1. response of ota start
    //2. reponse of new block
    //3. response of finish
    func onWriteCharacteristicValue(cha: CBCharacteristic, error: Error?) {
        if error != nil {
            var log = BLELog(desc: "Write error")
            log.error = String(describing: error)
            self.postLog(log)
            stateHelper.otaStateMachine.fire(transition: .ERROR)
            return
        }
        stateHelper.otaStateMachine.fire(transition: .WRITE_SUCCESS)
    }
    
    func onIsReadyToSendWriteWithoutResponse(peripheral: CBPeripheral) {
        self.busy = !peripheral.canSendWriteWithoutResponse
        //当满足一下条件，发送分包数据
        if !busy && bigDataCharacteristic != nil {
            
            //set progress value.
            let progressValue = calculateProgressValue()
            self.progressCallback?(["response": ProgressHandle(state: .onGoing, progress:ProgressValue(progressValue), error: nil)])
            
            if bigDataTasks.isEmpty {
                self.onBigDataSent()
                self.bigDataCharacteristic = nil
            } else {
                let cmd = bigDataTasks.remove(at: 0)
                BLEManager.ble().iOtaWrite(data: cmd, characteristic: bigDataCharacteristic!, type: .withoutResponse)
            }
        }
    }
 
   
    func onBigDataSent() {
        stateHelper.otaStateMachine.fire(transition: .SENT)
    }
    
    // MARK: 自动分包发送长数据
    //目前只支持20个字节
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
        } else {
            bigDataTasks.append(data)
        }
        BLEManager.ble().iOtaWrite(data: bigDataTasks.remove(at: 0), characteristic: characteristic, type: .withoutResponse)
    }
    
    func calculateProgressValue() -> Float  {
        didSendLength += 20
        guard let total = task?.data?.count else{
            return 0.0
        }
        var progress = Float(didSendLength) / Float(total)
        if progress > 1.00 {
            progress = 1.00
        }
        return progress
    }
    
}


extension String {
    
    var fileName :String {
        var newPath = self
        if let startIndex = self.lastIndex(of: "/") {
            let start = self.index(startIndex, offsetBy: 1)
            let range = start ..< self.endIndex
            newPath = String(self[range])
        }
        return newPath
    }
}
