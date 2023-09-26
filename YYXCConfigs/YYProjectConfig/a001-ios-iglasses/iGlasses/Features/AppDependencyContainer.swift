//
//  AppDependencyContainer.swift
//  iGlasses
//
//  Created by Matthew on 2021/4/14.
//

import Foundation

struct AppDependencyContainer {
    let sharedMainViewModel: MainViewModel
//    let sharedUserSessionRepository: UserSessionRepository

    init() {
      func makeMainViewModel() -> MainViewModel {
        return MainViewModel()
      }

      self.sharedMainViewModel = makeMainViewModel()
    }

    func makeMainViewController() -> MainVC {
        let launchViewControllerFactory = {
            LaunchDependencyContainer(appDependencyContainer: self).makeLaunchViewController()
        }
        let homeViewControllerFactory = {
            HomeDependencyContainer(appDependencyContainer: self).makeHomeViewController()
        }
        let splashViewControllerFactory = {
            SplashDependencyContainer(appDependencyContainer: self).makeSplashViewController()
        }
        return MainVC(viewModel: sharedMainViewModel,
                                  launchViewControllerFactory: launchViewControllerFactory,
                                  homeViewControllerFactory: homeViewControllerFactory,
                                  splashViewControllerFactory:splashViewControllerFactory)
    }

//    public func makeLaunchViewController() -> LaunchViewController {
//        let di = LaunchDependencyContainer(appDependencyContainer: self)
//        return di.makeLaunchViewController()
//    }
//    
//    public func makeGuideViewController() -> GuideViewController {
//      let di = GuideDependencyContainer(appDependencyContainer: self)
//      return di.makeGuideViewController()
//    }
}
