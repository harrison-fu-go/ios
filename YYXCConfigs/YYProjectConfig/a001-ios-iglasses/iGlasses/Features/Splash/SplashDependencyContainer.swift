//
//  SplashDependencyContainer.swift
//  iGlasses
//
//  Created by fuhuayou on 2021/4/19.
//

import Foundation

struct SplashDependencyContainer {
    let sharedMainViewModel: MainViewModel

    init(appDependencyContainer: AppDependencyContainer) {
        self.sharedMainViewModel = appDependencyContainer.sharedMainViewModel
    }

    func makeSplashViewController() -> SplashVC {
        return SplashVC(viewModel: makeSplashViewModel())
    }
}

extension SplashDependencyContainer: SplashViewModelFactory {
    func makeSplashViewModel() -> SplashViewModel {
        return SplashViewModel(navigateToHome: self.sharedMainViewModel)
    }
}
