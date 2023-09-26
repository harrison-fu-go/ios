//
//  InternalToggles.swift
//  iGlasses
//
//  Created by Matthew on 2021/4/13.
//

import Foundation

enum InternalToggle: String, ToggleType {
    case isTestButtonEnabled
}

struct InternalToggleController: ToggleController {
    private let userDefaults: UserDefaults

    private init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
        self.userDefaults.register(defaults: [
            InternalToggle.isTestButtonEnabled.rawValue: false
            ])
    }

    static let shared: InternalToggleController = .init(userDefaults: .standard)

    func isToggleOn(_ toggle: ToggleType) -> Bool {
        guard let toggle = toggle as? InternalToggle else {
            return false
        }

        return userDefaults.bool(forKey: toggle.rawValue)
    }

    func update(toggle: ToggleType, value: Bool) {
        guard let toggle = toggle as? InternalToggle else {
            return
        }

        userDefaults.set(value, forKey: toggle.rawValue)
    }
}
