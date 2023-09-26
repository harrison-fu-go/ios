//
//  InternalMenuActionTriggerItemViewModel.swift
//  iGlasses
//
//  Created by Matthew on 2021/4/13.
//

import Foundation

class InternalMenuActionTriggerItemViewModel: InternalMenuItemViewModel {
    let type: InternalMenuItemType  = .actionTrigger

    var title: String {
        fatalError(L10n.Development.fatalErrorSubclassToImplement)
    }

    // swiftlint:disable unavailable_function
    func select() {
        fatalError(L10n.Development.fatalErrorSubclassToImplement)
    }
}
