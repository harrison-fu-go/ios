//
//  HomeAppUpdateViewModel.swift
//  iGlasses
//
//  Created by fuhuayou on 2021/4/26.
//

import Foundation
import RxSwift

class HomeAppUpdateViewModel {
    
    let remoteService: GlassesRemoteService
    
    let appVersionSubject: PublishSubject<[String:String]> = PublishSubject()
    let errorSubject: PublishSubject<Error> = PublishSubject()
    var checkedVersion:AppVersion?
    private let disposeBag = DisposeBag()
    
    init(remoteService: GlassesRemoteService) {
        self.remoteService = remoteService
    }
    
    //swiftlint:disable force_unwrapping
    func checkAppVersion() {
        //get last check.
        let currentVersions = AppUpdateManager.currentVersion()
        let appVersion = AppUpdateManager.lastCheckAppVersion()
        if let appVersion = appVersion {
            let need = isNeedUpdate(curr: Int(currentVersions[1])!, new: appVersion.versionCode) ? "1" : "0"
            appVersionSubject.onNext(["currentVersion":currentVersions[0], "HaveUpdate":need, "newVersion":appVersion.latestVersion])
            setAppVersion(app: appVersion)
        } else {
            appVersionSubject.onNext(["currentVersion":currentVersions[0], "HaveUpdate":"0", "newVersion":""])
        }
        //set subscribe.
        AppUpdateManager.appVersionSubject.subscribe(onNext: { AppVersion in
            let need = self.isNeedUpdate(curr: Int(currentVersions[1])!, new: AppVersion.versionCode) ? "1" : "0"
            self.appVersionSubject.onNext(["currentVersion":currentVersions[0], "HaveUpdate":need, "newVersion":AppVersion.latestVersion])
            self.setAppVersion(app: AppVersion)
        }).disposed(by: disposeBag)
        AppUpdateManager.checkAppUpdate(remoteService: remoteService, isFromAppLanuch: false)
    }
    
    func isNeedUpdate(curr:Int, new:Int) -> Bool {
        return new > curr
    }
    
    func setAppVersion(app: AppVersion) {
        checkedVersion = app
    }
    
    //swiftlint:disable force_unwrapping
    func skipToDownloadApp() {
        if checkedVersion != nil {
            if UIApplication.shared.canOpenURL(checkedVersion!.linkAppStore) {
                UIApplication.shared.open(checkedVersion!.linkAppStore)
            }
        }
    }
}
