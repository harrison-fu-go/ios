//
//  InternalMenuFeatureToggleCell.swift
//  iGlasses
//
//  Created by Matthew on 2021/4/13.
//

import UIKit

class InternalMenuFeatureToggleCell: UITableViewCell, InternalMenuCellType {
    private let switchControl: UISwitch = configure(.init()) {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    private var item: InternalMenuFeatureToggleItemViewModel?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupUI()
    }

    // swiftlint:disable unavailable_function
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError(L10n.Development.fatalErrorInitCoderNotImplemented)
    }
    // swiftlint:enable unavailable_function

    func update(with item: InternalMenuItemViewModel) {
        guard let item = item as? InternalMenuFeatureToggleItemViewModel else {
            return
        }

        self.item = item
        textLabel?.text = item.title
        switchControl.isOn = item.isOn
    }

    func setupUI() {
        selectionStyle = .none
        accessoryView = switchControl
        switchControl.addTarget(self, action: #selector(onSwitchToggle), for: .valueChanged)
    }

    @objc
    func onSwitchToggle() {
        self.item?.toggle(isOn: switchControl.isOn)
    }
}
