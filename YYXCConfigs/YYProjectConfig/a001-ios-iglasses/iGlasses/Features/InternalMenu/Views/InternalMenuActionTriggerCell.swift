//
//  InternalMenuActionTriggerCell.swift
//  iGlasses
//
//  Created by Matthew on 2021/4/13.
//

import UIKit

class InternalMenuActionTriggerCell: UITableViewCell, InternalMenuCellType {
    func update(with item: InternalMenuItemViewModel) {
        guard let item = item as? InternalMenuActionTriggerItemViewModel else {
            return
        }

        accessoryType = .disclosureIndicator
        textLabel?.text = item.title
    }
}
