//
//  ConnectionNavModel.swift
//  iGlasses
//
//  Created by fuhuayou on 2021/4/20.
//

import Foundation

struct ConnectionDependencyContainer {
    
    let homeDependency: HomeDependencyContainer
    
    init(homeDependencyContainer: HomeDependencyContainer) {
        self.homeDependency = homeDependencyContainer
    }
    
    func makeConnectionRootVC() -> ConnectionRootVC {
        return ConnectionRootVC(viewModel: ConnectionRootViewModel())
    }
    
}
