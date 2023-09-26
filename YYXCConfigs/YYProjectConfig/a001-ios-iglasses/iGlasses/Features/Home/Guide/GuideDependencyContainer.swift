//
//  GuideNavModel.swift
//  iGlasses
//
//  Created by fuhuayou on 2021/4/20.
//

import UIKit

struct GuideDependencyContainer {
    
    let homeDependency: HomeDependencyContainer
    
    init(homeDependencyContainer: HomeDependencyContainer) {
        self.homeDependency = homeDependencyContainer
    }
    
    func makeGuideRootVC() -> GuideRootVC {
        let vc = GuideRootVC(viewModel: GuideRootViewModel(remoteService: homeDependency.remoteService)) { url -> BrowserVC in
            return homeDependency.makeBrowserViewController(with: url)
        }
        return vc
    }
    
    func makeOperateGuideVC() -> OperateGuideVC {
        return OperateGuideVC()
    }
    
    // 只是一个例子
    func makeSubVC1() -> UIViewController {
        return UIViewController()
    }
    // 只是一个例子
    func makeSubVC2() -> UIViewController {
        return UIViewController()
    }
    // 只是一个例子
    func makeSubVC3() -> UIViewController {
        return UIViewController()
    }
    
}
