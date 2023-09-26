//
//  UIApplicationExtension.swift
//  iGlasses
//
//  Created by Matthew on 2021/4/16.
//

import UIKit

extension UIApplication {
    var rootViewController: UIViewController? {
        let keyWindow = connectedScenes
                .filter({ $0.activationState == .foregroundActive })
                .map({ $0 as? UIWindowScene })
                .compactMap({ $0 })
                .first?.windows
                .first(where: { $0.isKeyWindow })
        return keyWindow?.rootViewController
    }

    static var appVersion: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0"
        // swiftlint:enable no_hardcoded_strings
    }

    var isRunningUnitTests: Bool {
        return NSClassFromString("XCTestCase") != nil
        // swiftlint:enable no_hardcoded_strings
    }
}
