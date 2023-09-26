//
//  MineRootViewModel.swift
//  iGlasses
//
//  Created by fuhuayou on 2021/4/20.
//

import Foundation
import RxSwift
struct MineRootViewModel {
    var items = [
//                 ["icon": "Push_Default", "title":"推送模式", "type": MineItemType.normal],
                 ["icon": "Battery_Default", "title":"省电模式", "type": MineItemType.switch],
                 ["icon": "lyrics_Default", "title":"歌词显示开关", "type": MineItemType.switch],
                 ["icon": "FirmwareUpdate_Default", "title":"眼镜端软件更新", "type": MineItemType.normal]]
    init() {
       let isHide = AppConfig.isAppStoreReviewing
        if !isHide {
            items.append(["icon": "SoftwareUpdate_Default", "title":"手机端软件更新", "type": MineItemType.withVersion])
        }
    }
    
    
    private let viewSubject = PublishSubject<String>()
    var deviceName: Observable<String> {
        return viewSubject.asObservable()
    }
    
    func refreshDeviceName() {
        let name:String = UserDefaults.standard.string(forKey: "A001DeviceName") ?? "DAVID-A001"
        viewSubject.onNext(name)
    }
    
    let firmwareVersion = PublishSubject<String>()
    func getFirmwareVersion() {
        HardwareUpdateManager.getCurrentVersion { success, info, _ in
            if success {
                firmwareVersion.onNext(info)
            }
        }
    }
    
    
    
}
