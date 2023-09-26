//
//  InternalMenuCrashAppItemViewModel.swift
//  iGlasses
//
//  Created by Matthew on 2021/4/13.
//

import Foundation

class InternalMenuCrashAppItemViewModel: InternalMenuActionTriggerItemViewModel {
    override var title: String {
        return L10n.InternalMenu.crashApp
    }

    // swiftlint:disable unavailable_function
    override func select() {
        // swiftlint:disable fatal_error_message
        fatalError()
    }
}
