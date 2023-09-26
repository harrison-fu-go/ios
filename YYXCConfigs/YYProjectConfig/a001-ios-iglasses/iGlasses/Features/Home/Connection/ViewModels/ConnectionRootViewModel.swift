//
//  ConnectionRootViewModel.swift
//  iGlasses
//
//  Created by fuhuayou on 2021/4/20.
//

import Foundation
import CoreBluetooth
import RxSwift
class ConnectionRootViewModel {
    
    let bleCenter = BLEManager.ble()
    init() {
        bleCenter.delegates.add(delegate: self)
    }

    let connectState = PublishSubject<BLEConnState>()
    
    let scanState = PublishSubject<Bool>()
    
    func connect(isEnable: Bool, isManual:Bool = true) {
        if isManual && bleCenter.centralState != .poweredOn {
            if isEnable {
                AlertViewPermission.popUp {
                    self.connectState.onNext(.disconnected)
                }
            }
            return
        }

        if isEnable {
            bleCenter.connectWithServiceUUIDs(services:BLE_CONFIG.services(),
                                              scanService:BLE_CONFIG.scanService(),
                                              deviceName: BLE_CONFIG.name(),
                                              timeout: 20) { message in
                print("============ connect message: ", message)
                let state = message["state"]
                guard let state = state as? BLETaskState else { return }
                if state == BLETaskState.timeout {
                    ZKToast.toast("请检查眼镜与蓝牙连接状态", title: "连接超时")
                } else if state == BLETaskState.fail {
                    ZKToast.toast(message["message"] as? String ?? "", title:"连接失败")
                    self.onConnectStateDidUpdate(state: .disconnected) //恢复状态
                }
            }
        } else {
            bleCenter.disconnect { message in
                print("============ disconnect message: ", message)
            }
        }
    }
    
    func firstTimeConnect() {
        let deviceInfo = bleCenter.getLastConnectDevcieInfo()
        if deviceInfo != nil {
            return
        }
        self.connect(isEnable: true, isManual: false)
    }
}

extension ConnectionRootViewModel:BLECenterProtocol {
    //power state.
    func onPowerStateDidUpdate(state: CBManagerState) {
//        print("==================== onPowerStateDidUpdate ======: ", state.rawValue)
    }

    //scan state.
    func onScanStateDidUpdate(isScan: Bool) {
        DispatchQueue.main.async {
            self.scanState.onNext(isScan)
        }
    }

    //connect state
    func onConnectStateDidUpdate(state: BLEConnState) {
        DispatchQueue.main.async {
            self.connectState.onNext(state)
        }
    }
}
