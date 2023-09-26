//
//  SplashViewModel.swift
//  iGlasses
//
//  Created by fuhuayou on 2021/4/19.
//

import Foundation

struct SplashViewModel {
    let navigateToHome: NavigateToHomeProtocol

    init(navigateToHome: NavigateToHomeProtocol) {
        self.navigateToHome = navigateToHome
    }

    func gotoHome() {
        navigateToHome.navigateToHome()
    }
}
