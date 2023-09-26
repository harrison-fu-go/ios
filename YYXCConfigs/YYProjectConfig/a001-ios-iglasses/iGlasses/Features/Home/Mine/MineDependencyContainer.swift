//
//  MineNavModel.swift
//  iGlasses
//
//  Created by fuhuayou on 2021/4/20.
//

import Foundation

struct MineDependencyContainer {
    
    let homeDependency: HomeDependencyContainer
    let remoteService: GlassesRemoteService
    
    init(homeDependency: HomeDependencyContainer) {
        self.homeDependency = homeDependency
        self.remoteService = homeDependency.remoteService
    }
    
    func makeMineRootVC() -> MineRootVC {
        return MineRootVC(viewModel: MineRootViewModel(), mineDependency: self)
    }
    
    func makePushModeVC() -> PushModeVC {
        let viewModel = PushModeViewModel()
        return PushModeVC(viewModel: viewModel)
    }
    
    func makeHardwareUpdateVC() -> HardwareUpdateVC {
        let viewModel = HardwearUpdateViewModel(remoteService: self.remoteService)
        return HardwareUpdateVC(viewModel: viewModel)
    }
    
    func makeHomeAppUpdateVC() -> HomeAppUpdateVC {
        let viewModel = HomeAppUpdateViewModel(remoteService: self.remoteService)
        return HomeAppUpdateVC(viewModel: viewModel)
    }
    
    func makeWearManageVC() -> WearManageVC {
        return WearManageVC()
    }
    
    func makeOperatingInstructionsVC() -> OperatingInstructionsVC {
        return OperatingInstructionsVC()
    }
    
    func makeModifyDeviceNameVC() -> ModifyDeviceNameVC {
        return ModifyDeviceNameVC()
    }
    
    
}
