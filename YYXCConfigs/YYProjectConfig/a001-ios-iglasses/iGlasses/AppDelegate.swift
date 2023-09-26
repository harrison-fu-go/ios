//
//  AppDelegate.swift
//  iGlasses
//
//  Created by Matthew on 2021/4/9.
//

import UIKit
import Bugly

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        print(L10n.userNameKey)
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.

        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

private extension AppDelegate {
    func onLaunch() {
    }
}

extension UIWindow {
    override open func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        let toggleController: ToggleController = BuildTargetToggleController.shared
        if toggleController.isToggleOn(BuildTargetToggle.debug)
            || toggleController.isToggleOn(BuildTargetToggle.internal) {
//            let router: AppRouting = AppRouter.shared
            if motion == .motionShake {
//                let trackingRepo: TrackingRepoType = TrackingRepo.shared
//                trackingRepo.trackEvent(TrackingEvent(name: "shake", parameters: ["userID": UserDataStore.current.userID, "datetime": Date()]))
//                router.route(to: URL(string: "\(UniversalLinks.baseURL)InternalMenu"), from: rootViewController, using: .present)
//                // swiftlint:enable no_hardcoded_strings
                let internalMenuVC = InternalMenuViewController()
                let navigationVC = UINavigationController(rootViewController: internalMenuVC)
                rootViewController?.showDetailViewController(navigationVC, sender: nil)
            }
        }
    }
}
 
