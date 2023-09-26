//
//  InternalMenuFeatureToggleItemViewModel.swift
//  iGlasses
//
//  Created by Matthew on 2021/4/13.
//

import Foundation

class InternalMenuFeatureToggleItemViewModel: InternalMenuItemViewModel {
    private let toggle: ToggleType
    private let toggleController: ToggleController

    init(title: String, toggle: ToggleType, toggleController: ToggleController = InternalToggleController.shared) {
        self.title = title
        self.toggle = toggle
        self.toggleController = toggleController
    }

    let type: InternalMenuItemType = .featureToggle
    let title: String

    var isOn: Bool {
       return toggleController.isToggleOn(toggle)
    }

    func toggle(isOn: Bool) {
        toggleController.update(toggle: toggle, value: isOn)
    }
}
