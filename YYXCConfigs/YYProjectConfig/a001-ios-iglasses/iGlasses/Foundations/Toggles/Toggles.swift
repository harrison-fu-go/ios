//
//  ToggleType.swift
//  iGlasses
//
//  Created by Matthew on 2021/4/13.
//

import Foundation

protocol ToggleType {
}

protocol ToggleController {
    func isToggleOn(_ toggle: ToggleType) -> Bool

    func update(toggle: ToggleType, value: Bool)
}
