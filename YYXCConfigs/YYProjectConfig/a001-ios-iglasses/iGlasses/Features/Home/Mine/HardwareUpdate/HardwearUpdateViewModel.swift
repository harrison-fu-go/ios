//
//  HardwearUpdateViewModel.swift
//  iGlasses
//
//  Created by Matthew on 2021/4/23.
//

import Foundation
import RxSwift
import RxCocoa

struct HardwearUpdateViewModel {
    
    let remoteService: GlassesRemoteService
    let resultSubject: PublishSubject<FirmwareVersion> = PublishSubject()
    let errorSubject: PublishSubject<Error> = PublishSubject()
    private let disposeBag = DisposeBag()
    
    //current version
    let currentVersion:PublishSubject<String> = PublishSubject()
    func getCurrentVersion() {
        HardwareUpdateManager.getCurrentVersion {success, version, _ in
            if success {
                var iVersion = version
                self.currentVersion.onNext("HOLOEVER" + iVersion.remove(char: "V"))
            }
        }
    }
    
    //check if have new version haveUpdate: true  version: V1.0.1  message: ...
    let newVersion:PublishSubject<[String:Any]> = PublishSubject()
    func checkNewVersion() {
        HardwareUpdateManager.hardwareVersionSubject.subscribe(onNext: { version in
            newVersion.onNext(version)
        }).disposed(by: disposeBag)
        HardwareUpdateManager.checkHardwareUpdate(remoteService: remoteService)
    }

    //download firmware.
    let downloadHandle:PublishSubject<ProgressHandle> = PublishSubject()
    func downloadFirmware() {
        HardwareUpdateManager.downloadFirmware(remoteService: remoteService, callback: { handle in
            downloadHandle.onNext(handle)
        })
    }
    
    let updateHandle:PublishSubject<ProgressHandle> = PublishSubject()
    func udpateFirmware() {
        HardwareUpdateManager.updateFirmware(remoteService: remoteService, callback: { handle in
            updateHandle.onNext(handle)
        })
    }
    
}
