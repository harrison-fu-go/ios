//
//  HomeDependencyContainer.swift
//  iGlasses
//
//  Created by Matthew on 2021/4/15.
//

import UIKit

struct HomeDependencyContainer {
    let iDependency: AppDependencyContainer
    let remoteService: GlassesRemoteService
    
    init(appDependencyContainer: AppDependencyContainer, remoteService: GlassesRemoteService = GlassesRemoteServiceImpl()) {
        self.iDependency = appDependencyContainer
        self.remoteService = remoteService
    }

    func makeHomeViewController() -> HomeVC {
        return HomeVC(viewModel: HomeViewModel(remoteService: self.remoteService),
                      guide: makeGuideVC(),
                      connection: makeConnectionVC(),
                      mine: makeMineVC())
    }

    func makeBrowserViewController(with url: URL) -> BrowserVC {
        let viewModel = BrowserViewModel(link: url)
        return BrowserVC(viewModel: viewModel)
    }
}

extension HomeDependencyContainer {
    private func makeGuideVC() -> GuideNC {
        let guideDependency = GuideDependencyContainer(homeDependencyContainer: self)
        return GuideNC(dependency:guideDependency)
    }

    private func makeConnectionVC() -> ConnectionNC {
        let connectionDependency = ConnectionDependencyContainer(homeDependencyContainer: self)
        return ConnectionNC(dependency: connectionDependency)
    }

    private func makeMineVC() -> MineNC {
        let mineDenpendency = MineDependencyContainer(homeDependency: self)
        return MineNC(dependency: mineDenpendency)
    }
}
