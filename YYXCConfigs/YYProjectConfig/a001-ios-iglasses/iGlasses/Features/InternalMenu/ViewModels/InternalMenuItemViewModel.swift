//
//  InternalMenuItemViewModel.swift
//  iGlasses
//
//  Created by Matthew on 2021/4/13.
//

import Foundation

enum InternalMenuItemType: String {
    case description
    case featureToggle
    case actionTrigger
}

protocol InternalMenuItemViewModel {
    var type: InternalMenuItemType { get }
    var title: String { get }

    func select()
}

extension InternalMenuItemViewModel {
    func select() { }
}
