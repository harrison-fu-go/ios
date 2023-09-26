//
//  LaunchViewModel.swift
//  iGlasses
//
//  Created by Matthew on 2021/4/15.
//

import Foundation

struct LaunchViewModel {
    let navigateToHome: NavigateToHomeProtocol

    init(navigateToHome: NavigateToHomeProtocol) {
        self.navigateToHome = navigateToHome
    }
}
