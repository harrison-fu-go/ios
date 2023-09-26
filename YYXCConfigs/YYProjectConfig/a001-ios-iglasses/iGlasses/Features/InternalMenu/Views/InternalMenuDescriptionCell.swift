//
//  InternalMenuDescriptionCell.swift
//  iGlasses
//
//  Created by Matthew on 2021/4/13.
//

import UIKit

class InternalMenuDescriptionCell: UITableViewCell, InternalMenuCellType {
    func update(with item: InternalMenuItemViewModel) {
        guard let item = item as? InternalMenuDescriptionItemViewModel else {
            return
        }

        selectionStyle = .none
        textLabel?.text = item.title
    }
}
