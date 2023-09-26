//
//  AppUpdateManager.swift
//  iGlasses
//
//  Created by zk-fuhuayou on 2021/5/17.
//

import Foundation
import RxSwift
enum AppUpdateCase {
    case no
    case have
    case have_force
}

struct AppUpdateManager {
    var isFromAppLanuch = true
    let remoteService: GlassesRemoteService
    let disposeBag = DisposeBag()
    
    static let appVersionSubject: PublishSubject<AppVersion> = PublishSubject()

    init(remoteService: GlassesRemoteService, isFromAppLanuch: Bool) {
        self.remoteService = remoteService
        self.isFromAppLanuch = isFromAppLanuch
    }
    
    func checkIfNeedUpdate() {
        do {
            let version: String = try Configuration.value(for: "CFBundleShortVersionString")
            let code: Int = try Configuration.value(for: "PRODUCT_VERSION_CODE")
            self.remoteService.checkAppVersion(version, code: code).subscribe { response in
                //1. Update to database
                let taskModel = DatabaseModel.copyModel(obj: response)
                taskModel.setAssociateValues(values: [["key": "linkAppStore", "value":response.linkAppStore.absoluteString],
                                                      ["key": "forceUpdate", "value":String(response.forceUpdate)]])
                DatabaseCenter.updateAppInfo(taskModel)
                
                //2. check if have update
                var isHaveUpdate = false
                if response.versionCode > code {
                    isHaveUpdate = true
                }
                
                //3. goto
                if isHaveUpdate && isFromAppLanuch {
                    self.gotoPopUpUpdate(response: response)
                } else {
                    AppUpdateManager.appVersionSubject.onNext(response)
                }
            } onFailure: { error in
                print("========== CHECK APP UPDATE ERROR ==========", error)
            }.disposed(by: self.disposeBag)
        } catch {
            print("========== CHECK APP UPDATE ERROR ==========", error)
        }
    }
    
    func gotoPopUpUpdate(response: AppVersion) {
        AppUpdateView.popUp(content: response) {
            AppUpdateManager.cancle()
        }
    }
}

extension AppUpdateManager {
    
    static var currenManager: AppUpdateManager?
    
    static func checkAppUpdate(remoteService: GlassesRemoteService, isFromAppLanuch:Bool = true) {
        if currenManager != nil && isFromAppLanuch {
            return
        }
        currenManager = AppUpdateManager(remoteService: remoteService, isFromAppLanuch:isFromAppLanuch)
        //goto check.
        currenManager?.checkIfNeedUpdate()
    }
    
    static func cancle() {
        self.currenManager = nil
    }
    
    static func currentVersion() -> [String] {
        do {
            let version: String = try Configuration.value(for: "CFBundleShortVersionString")
            let code: Int = try Configuration.value(for: "PRODUCT_VERSION_CODE")
            return [version, String(code)]
        } catch {
            return ["", ""]
        }
    }
    
    //swiftlint:disable force_unwrapping
    static func lastCheckAppVersion() -> AppVersion? {
        let lastGetInfo = DatabaseCenter.getLatestAppInfo()
        if let lastGetInfo = lastGetInfo {
            let latestVersion = lastGetInfo.associateValue(key: "latestVersion") ?? ""
            let versionCode = Int(lastGetInfo.associateValue(key: "versionCode") ?? "0") ?? 0
            let updateDesc = lastGetInfo.associateValue(key: "updateDesc") ?? ""
            let linkAppStore = lastGetInfo.associateValue(key: "linkAppStore") ?? "https://apps.apple.com/cn/app/id590338362"
            let appVersion = AppVersion(latestVersion: latestVersion,
                                        versionCode: versionCode,
                                        linkAppStore: URL(string: linkAppStore)!,
                                        forceUpdate: false,
                                        updateDesc: updateDesc)
            return appVersion
        }
        return nil
    }
}
