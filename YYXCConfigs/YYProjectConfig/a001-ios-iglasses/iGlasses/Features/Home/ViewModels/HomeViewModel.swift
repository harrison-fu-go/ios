//
//  HomeViewModel.swift
//  iGlasses
//
//  Created by Matthew on 2021/4/15.
//

import Foundation
import RxSwift

struct HomeViewModel {
    let remoteService: GlassesRemoteService
    let disposeBag = DisposeBag()
    
    init(remoteService: GlassesRemoteService) {
        self.remoteService = remoteService
    }
    
    //check update
    func checkAppUpdate() {
        AppUpdateManager.checkAppUpdate(remoteService: self.remoteService)
    }
    
    func loadAppRemoteConfig() {
        //swiftlint:disable force_try
        let version: String = try! Configuration.value(for: "CFBundleShortVersionString")
        remoteService.requestAppRemoteConfig(version: version)
            .subscribe { config in
                AppConfig.isAppStoreReviewing = config.isAppStoreReviewing
            }.disposed(by: self.disposeBag)
        
    }
}
