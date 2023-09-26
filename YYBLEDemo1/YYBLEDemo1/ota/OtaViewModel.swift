//
//  OtaViewModel.swift
//  BLETools
//
//  Created by 钟城广 on 2020/12/14.
//

import Foundation
import CoreBluetooth

class OtaViewModel :ObservableObject, RemotePeripherlDelegate{
    
    var ctrlCharacteristic: CBCharacteristic? = nil
    var dataCharacteristic: CBCharacteristic? = nil
    @Published var paths = [String]()
    @Published var isUpdating = false
    @Published var logs = [BLELog]()
    var task: OtaTask? = nil
    let stateHelper = OtaStateHelper()
    
    init() {
        self.paths = Bundle.main.paths(forResourcesOfType: "bin", inDirectory: nil)
        stateHelper.stateMachine.add(state: .IDLE){
            print("IDLE; last: \(String(describing: self.stateHelper.stateMachine.lastTransition))")
        }
        stateHelper.stateMachine.add(state: .PREPARE){
            self.setUpdate(aBool: true)
            print("PREPARE")
            self.prepare()
        }
        stateHelper.stateMachine.add(state: .START_OTA){
            self.setUpdate(aBool: true)
            print("START_OTA")
            self.requestOtaStart()
        }
        stateHelper.stateMachine.add(state: .NEXT_BLOCK){
            self.setUpdate(aBool: true)
            print("NEXT_BLOCK")
            self.requestNextBlock()
        }
        stateHelper.stateMachine.add(state: .TRANSFER_SEGMENT){
            self.setUpdate(aBool: true)
            print("TRANSFER_SEGMENT")
            self.transferSegment()
        }
        stateHelper.stateMachine.add(state: .CHECK_ACK){
            self.setUpdate(aBool: true)
            print("CHECK_ACK")
            self.readAck()
        }
        stateHelper.stateMachine.add(state: .FINISH){
            self.setUpdate(aBool: false)
            print("FINISH")
            self.allDataSent()
        }
        stateHelper.stateMachine.add(state: .FAILED){
            self.setUpdate(aBool: false)
        }
        stateHelper.stateMachine.initialState = .IDLE
    }
    
    func setup() {
        BLEManager.shared().remotePeripheralDelegate = self
    }
    
    private func setUpdate(aBool:Bool){
        if(isUpdating != aBool){
            DispatchQueue.main.async {
                self.isUpdating = aBool
            }
        }
    }
    
    func start(service:CBService, path:String){
        self.mService = service
        self.mPath = path
        //idle > Start
        stateHelper.stateMachine.fire(transition: .Confiing)
        setUpdate(aBool: true)
    }
    
    func cancel(){
        BLEManager.shared().remotePeripheralDelegate = nil
    }
    
    //read indicate
    func onReceived(remote: CBPeripheral, characteristic: CBCharacteristic, error: Error?) {
        if error != nil {
            var log = BLELog(desc: "OnReceived")
            log.error = String(describing: error)
            self.postLog(log)
            stateHelper.stateMachine.fire(transition: .ERROR)
            return
        }
        guard let value = characteristic.value else {
            return
        }
        //read ack
        if characteristic == dataCharacteristic {
            var log = BLELog(desc: "Received ACK")
            log.data = value
            self.postLog(log)
            let needResend = task?.needResendSegments(ack: value) ?? false
            if needResend {
                stateHelper.stateMachine.fire(transition: .RESEND)
            }else {
                stateHelper.stateMachine.fire(transition: .RECEIVED)
            }
        }
        if characteristic == ctrlCharacteristic {
            var log = BLELog(desc: "Received Indicate")
            log.data = value
            self.postLog(log)
            if value[0] == 1 && value[1] == 0 {
                task?.setup(maxSegmentNumInBlock: Int(value[2]) * 8)
                stateHelper.stateMachine.fire(transition: .RECEIVED)
            }
        }
    }
    
    //1. response of ota start
    //2. reponse of new block
    //3. response of finish
    func onWrite(remote: CBPeripheral, characteristic: CBCharacteristic, error: Error?) {
        if error != nil {
            var log = BLELog(desc: "Write error")
            log.error = String(describing: error)
            self.postLog(log)
            stateHelper.stateMachine.fire(transition: .ERROR)
            return
        }
        stateHelper.stateMachine.fire(transition: .WRITE_SUCCESS)
    }
    
    func onBigDataSent() {
        stateHelper.stateMachine.fire(transition: .SENT)
    }
    
    // MARK: 操作
    private var mService: CBService? = nil
    private var mPath:String? = nil
    // Step 1 准备数据，并开启Indicate
    private func prepare(){
        var log = BLELog(desc: "OTA: Data preparation")
        if mPath == nil || mService == nil {
            log.error = "Invalid Data"
            postLog(log)
            stateHelper.stateMachine.fire(transition: .ERROR)
            return
        }
        task = OtaTask(path: mPath!)
        mService!.characteristics?.forEach({ (characteristic) in
            if(characteristic.uuid.uuidString.contains("7000")){
                ctrlCharacteristic = characteristic
            }
            if(characteristic.uuid.uuidString.contains("7001")){
                dataCharacteristic = characteristic
            }
        })
        if ctrlCharacteristic == nil || dataCharacteristic == nil {
            log.error = "No Match service"
            postLog(log)
            stateHelper.stateMachine.fire(transition: .ERROR)
            return
        }
        BLEManager.shared().notify(characteristic: ctrlCharacteristic!)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5){
            if self.ctrlCharacteristic?.isNotifying == true {
                self.stateHelper.stateMachine.fire(transition: .START)
            }else{
                var log = BLELog(desc: "OTA: Data preparation")
                log.error = "Indicate open exception"
                self.postLog(log)
                self.stateHelper.stateMachine.fire(transition: .ERROR)
            }
        }
    }
    
    private  func requestOtaStart(){
        var log = BLELog(desc: "Request to start OTA")
        guard let cmd = task?.startPkt() else {
            log.error = "Invalid data"
            stateHelper.stateMachine.fire(transition: .ERROR)
            postLog(log)
            return
        }
        if self.ctrlCharacteristic == nil {
            log.error = "No Match Characteristic"
            stateHelper.stateMachine.fire(transition: .ERROR)
            postLog(log)
            return
        }
        BLEManager.shared().write(data: cmd,characteristic: self.ctrlCharacteristic!,type: .withResponse)
        log.data = cmd
        postLog(log)
    }
    
    private func requestNextBlock(){
        var log = BLELog(desc: "Request to write a new block")
        if self.ctrlCharacteristic == nil {
            log.error = "No Match Characteristic"
            postLog(log)
            stateHelper.stateMachine.fire(transition: .ERROR)
            return
        }
        guard let cmd = task?.loadNextBlockPacket() else {
            stateHelper.stateMachine.fire(transition: .DONE)
            return
        }
        BLEManager.shared().write(data: cmd, characteristic: ctrlCharacteristic!, type: .withResponse)
        log.data = cmd
        postLog(log)
    }
    
    private func transferSegment(){
        var log = BLELog(desc: "Writes all segments of the block")
        if self.dataCharacteristic == nil {
            log.error = "No Match Characteristic"
            postLog(log)
            stateHelper.stateMachine.fire(transition: .ERROR)
            return
        }
        guard let data = task?.loadAllDataOfBlock() else {
            log.error = "Invalid data"
            postLog(log)
            return
        }
        BLEManager.shared().WrtieBigData(data: data, characteristic: dataCharacteristic!)
        log.data = data
        postLog(log)
    }
    
    private func readAck(){
        var log = BLELog(desc: "Read ACK")
        if self.dataCharacteristic == nil {
            log.error = "No Match Characteristic"
            postLog(log)
            stateHelper.stateMachine.fire(transition: .ERROR)
            return
        }
        BLEManager.shared().read(characteristic: dataCharacteristic!)
        postLog(log)
    }
    
    private func allDataSent(){
        var log = BLELog(desc: "All data is transferred")
        if self.ctrlCharacteristic == nil {
            log.error = "No Match Characteristic"
            postLog(log)
            stateHelper.stateMachine.fire(transition: .ERROR)
            return
        }
        let cmd = Data.init([3])
        BLEManager.shared().write(data: cmd, characteristic: ctrlCharacteristic!, type: .withResponse)
        log.data = cmd
        postLog(log)
    }
    
    private func postLog(_ log:BLELog) {
        DispatchQueue.main.async {
            self.logs.append(log)
        }
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "OTA"), object: nil, userInfo: ["log": log])
    }
}

extension String {
    
    var fileName :String {
        var newPath = self
        if let startIndex = self.lastIndex(of: "/") {
            let start = self.index(startIndex, offsetBy: 1)
            let range = start ..< self.endIndex
            newPath =  String(self[range])
        }
        return newPath
    }
}
