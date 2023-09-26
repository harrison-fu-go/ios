//
//  LaunchDependencyContainer.swift
//  iGlasses
//
//  Created by Matthew on 2021/4/15.
//

import Foundation

struct LaunchDependencyContainer {
    let sharedMainViewModel: MainViewModel
//    let sharedUserSessionRepository: UserSessionRepository

    init(appDependencyContainer: AppDependencyContainer) {
        self.sharedMainViewModel = appDependencyContainer.sharedMainViewModel
//        self.sharedUserSessionRepository = appDependencyContainer.sharedUserSessionRepository
    }

    func makeLaunchViewController() -> LaunchVC {
        return LaunchVC(viewModel: makeLaunchViewModel())
    }
}

extension LaunchDependencyContainer: LaunchViewModelFactory {
    func makeLaunchViewModel() -> LaunchViewModel {
        return LaunchViewModel(navigateToHome: self.sharedMainViewModel)
    }
}
