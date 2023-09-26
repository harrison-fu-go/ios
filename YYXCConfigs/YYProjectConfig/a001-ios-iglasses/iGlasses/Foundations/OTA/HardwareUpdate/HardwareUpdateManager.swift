//
//  HardwareUpdateManager.swift
//  iGlasses
//
//  Created by zk-fuhuayou on 2021/5/28.
//

import UIKit
import RxSwift
struct HardwareUpdateManager {
    static var manager: HardwareUpdateManager?
    let remoteService: GlassesRemoteService
    let disposeBag = DisposeBag()
    var disposeDownloadBag:DisposeBag? = DisposeBag()
    //1. check if have new version.
    static let hardwareVersionSubject: PublishSubject<[String:Any]> = PublishSubject()
    static var latestFirmware: FirmwareVersion?
    func checkIsHaveNewVerson() {
        self.remoteService.checkFirmwareVersion("v1.0.0", code: 1)
            .subscribe(onSuccess: { version in
                HardwareUpdateManager.latestFirmware = version
                self.checkIsNeedUpdate(versionModel: version) {need in
                    HardwareUpdateManager.hardwareVersionSubject.onNext(["haveUpdate":need, "version":version.latestVersion, "message":version.updateDesc])
                }
            }, onFailure: { error in
                HardwareUpdateManager.hardwareVersionSubject.onNext(["haveUpdate":false, "version":"", "message":error.localizedDescription])
            }).disposed(by: disposeBag)
    }
    
    //swiftlint:disable force_unwrapping
    func checkIsNeedUpdate(versionModel: FirmwareVersion, callback: ZKCallback<Bool>?) {
        HardwareUpdateManager.getCurrentVersion { success, version, _ in
            if success {
                let currentVersions = version.remove(members: "v", "V").split(separator: ".")
                let newVersions = versionModel.latestVersion.remove(members: "v", "V").split(separator: ".")
                let currentValue = (Int(currentVersions[0])! * 100) + (Int(currentVersions[1])! * 10) + Int(currentVersions[2])!
                let newValue = (Int(newVersions[0])! * 100) + (Int(newVersions[1])! * 10) + Int(newVersions[2])!
                callback?(newValue > currentValue)
            } else {
                callback?(false)
            }
        }
    }
    
    
    //2. go to download.
    func downloadFirmware(callback:@escaping ZKCallback<ProgressHandle>) {
        guard let lastFirmware = HardwareUpdateManager.latestFirmware else {
            callback(ProgressHandle(state:.error, progress: 0, error: NSError.error(code: 10000, messge: "Latest firmware null.")))
            return
        }
        let url = lastFirmware.download.absoluteString
        let source = self.remoteService.downloadFile(url: url)
        let result = source.observe(on:MainScheduler.asyncInstance).subscribe(onNext: {pr in
            if pr.response?.statusCode ?? 0 > 200 {
                print("========= downloadForUpdate ===== error: ", pr.response?.statusCode ?? 0)
                callback(ProgressHandle(state:.error, progress: 0, error: NSError.error(code: 10000, messge:"Request error.")))
            } else if pr.completed {
                print("========= downloadForUpdate ===== completed")
                callback(ProgressHandle(state:.complete, progress: 1.0, error: nil))
            } else {
                print("========= downloadForUpdate ===== progress: ", pr.progress)
                callback(ProgressHandle(state:.onGoing, progress: pr.progress, error: nil))
            }
        }, onError: {error in
            callback(ProgressHandle(state:.error, progress: 0, error: NSError.error(code: 10000, messge: error.localizedDescription)))
        })
        result.disposed(by: self.disposeDownloadBag!)
    }
    
    //swiftlint:disable force_cast
    mutating func updateFirmware(callback:@escaping ZKCallback<ProgressHandle>) {
        guard let lastFW = HardwareUpdateManager.latestFirmware else {
            callback(ProgressHandle(state:.error, progress:0, error: NSError.error(code: 10000, messge: "Latest firmware null.")))
            return
        }
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! + "/" + lastFW.download.lastPathComponent
        BLEManager.ble().gotoOta(filePath: path) { progress in
            let handle = progress["response"] as! ProgressHandle
            callback(handle) //["response": ProgressHandle(state: .onGoing, message: String(progressValue), error: nil)]
        } callback: { response in
            let handle = response["response"] as! ProgressHandle
            callback(handle)
        }
    }
    
    //3. cancel download.
    mutating func cancelDownload() {
        self.disposeDownloadBag = nil
    }
}

extension HardwareUpdateManager {

    static func checkHardwareUpdate(remoteService: GlassesRemoteService) {
        manager = HardwareUpdateManager(remoteService: remoteService)
        manager?.checkIsHaveNewVerson()
    }
    
    static func downloadFirmware(remoteService: GlassesRemoteService, callback:@escaping ZKCallback<ProgressHandle>) {
        manager = HardwareUpdateManager(remoteService: remoteService)
        manager?.downloadFirmware(callback: callback)
    }
    
    static func updateFirmware(remoteService: GlassesRemoteService, callback:@escaping ZKCallback<ProgressHandle>) {
        manager = HardwareUpdateManager(remoteService: remoteService)
        manager?.updateFirmware(callback: callback)
    }
    
    static func getCurrentVersion(callback: GetCallback<String>) {
        callback(true, "V1.0.0", "")
    }
}
