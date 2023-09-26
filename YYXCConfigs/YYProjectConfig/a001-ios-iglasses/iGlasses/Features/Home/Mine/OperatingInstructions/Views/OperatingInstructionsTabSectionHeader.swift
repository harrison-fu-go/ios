//
//  OperatingInstructionsTabSectionHeader.swift
//  iGlasses
//
//  Created by fuhuayou on 2021/4/21.
//

import UIKit

// swiftlint:disable private_outlet
// swiftlint:disable prohibited_interface_builder
class OperatingInstructionsTabSectionHeader: UITableViewHeaderFooterView {

    @IBOutlet weak var titelLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}


extension OperatingInstructionsTabSectionHeader {
    open override var backgroundColor: UIColor? {
        get {
            return self.backgroundView?.backgroundColor ?? UIColor.clear
        }
        set {
            let bgView = UIView()
            bgView.backgroundColor = newValue
            backgroundView = bgView
        }
    }
}
