//
//  BLEOTAMgr.swift
//  YYBLEDemo1
//
//  Created by fuhuayou on 2021/4/8.
//
import CoreBluetooth
import Foundation
//swiftlint:disable force_unwrapping force_cast
class BLEOTAMgr: NSObject {

    var progressCallbcak: BLECALLBACK?
    
    var bleCenter: BLECenter?
    var filePath: String?
    var inputStream: InputStream? // 数据流
    var perMaxLength: Int = 180 // 每次读取长度
    var fileSize: Int64? // 文件大小
    var sentSize: Int64 = Int64(0)  // 已经发送的长度
    
    var stepCallback: ZKCallback<ProgressHandle>?
    init(_ ble: BLECenter?, _ file: String?) {
        super.init()
        bleCenter = ble
        filePath = file
    }
    
    //OTA Start request
    func otaStart(_ filePath:String, _ callback: BLECALLBACK?) {
//        self.filePath = filePath
        self.filePath = Bundle.main.path(forResource: "template_ota", ofType: "bin")
        print("===== filePath:  " + self.filePath!)
        self.progressCallbcak = callback
        
        //1, send request.
        let otaCommand:[UInt8] = [0x00, 0x13, 0x00]
        stepCallback = { resonse in
            if(resonse.message == "START") {
                
            }
        }
        self.bleCenter?.iSendData(data: otaCommand,
                                  service: BLEConstants.OTA_SERVER,
                                  characteristic: BLEConstants.OTA_CHARACTERISTIC0,
                                  type: .withResponse)
        
        //2....
        
//        self.resume()
    }
    
    
    //if force deinit the instace then remove the inputStream.
    deinit {
        self.inputStream?.close()
        self.inputStream?.remove(from: .current, forMode: RunLoop.Mode.default)
        self.inputStream = nil
    }
    
}
//
//// MARK: hello
//// send data stream.
//extension BLEOTAMgr: StreamDelegate {
//
//    func resume() {
//        guard let filePath = self.filePath else {
//            self.execProgress(success: .error, message: "File path null")
//            return
//        }
//
//        if !(FileManager.default.fileExists(atPath: filePath)) {
//            self.execProgress(success: .error, message: "File null")
//            return
//        }
//
//        do {
//            let fileAttributes = try FileManager.default.attributesOfItem(atPath:filePath)
//            if let fileSize = fileAttributes[FileAttributeKey.size] {
//                self.fileSize = (fileSize as! NSNumber).int64Value
//            }
//        } catch {
//            self.execProgress(success: .error, message: "Could not get file size.")
//            return
//        }
//
//        if self.fileSize == 0 {
//            self.execProgress(success: .error, message: "File length == 0")
//            return
//        }
//
//        // init inputStream
//        if self.inputStream == nil {
//            let backgroundQueue = DispatchQueue.global(qos: .background)
//            backgroundQueue.async {
//                self.inputStream = InputStream(fileAtPath: filePath)
//                self.inputStream?.delegate = self
//                self.inputStream?.schedule(in: RunLoop.current, forMode: RunLoop.Mode.default)
//                self.inputStream?.open()
//                RunLoop.current.run()
//            }
//        }
//    }
//
//    // deleagate methods.
//    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
//        let inputStream: InputStream = aStream as! InputStream
//        switch eventCode {
//        case Stream.Event.openCompleted:
//            print("=====Stream.Event.openCompleted=====")
//        case Stream.Event.hasBytesAvailable:
//            let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: perMaxLength)
//            let readBufferIsAvailable = inputStream.read(buffer, maxLength: perMaxLength)
//            if readBufferIsAvailable > 0 {
//                let temData = Data(bytes: buffer, count: readBufferIsAvailable)
//                sentSize += Int64(readBufferIsAvailable)
//                print("======== temData =========", temData)
//                print("======== sentSize =========", sentSize)
//                // send data.
//                print("=========== sentSize: \(sentSize) ==== data: \(temData)")
//                self.execProgress(success: .onGoing, progress: (Double(sentSize) / Double(self.fileSize!)))
//            }
//        case Stream.Event.hasSpaceAvailable:
//            break
//        case Stream.Event.errorOccurred:
//            print("=====Stream.Event.errorOccurred=====")
//            self.execProgress(success: .error, message: "Input stream data error.")
//        case Stream.Event.endEncountered:
//            print("=====Stream.Event.endEncountered=====")
//            self.execProgress(success: .complete, message: "Success.")
//        default:
//            break
//        }
//    }
//
//    func execProgress(success: SuccessFlag, message: String? = nil, progress:Double = 0) {
//        var error:NSError?
//        if let message = message {
//            error = NSError.error(messge: message)
//        }
//        self.progressCallbcak?(["response" : ProgressHandle(state:success, progress: progress, error: error)])
//
//        if success == .error {
//            self.inputStream?.close()
//            self.inputStream?.remove(from: .current, forMode: RunLoop.Mode.default)
//            self.inputStream = nil
//        }
//    }
//}
//
//extension BLEOTAMgr: BLECenterProtocol {
//    func onUpdateCharacteristicValue(cha: CBCharacteristic, error:Error?) {
//        if cha.service.uuid.uuidString == BLEConstants.OTA_SERVER && cha.uuid.uuidString == BLEConstants.OTA_CHARACTERISTIC0 {
//            stepCallback?(ProgressHandle(message: "START"))
//        }
//    }
//
//    func onWriteCharacteristicValue(cha: CBCharacteristic) {
//
//    }
//}
