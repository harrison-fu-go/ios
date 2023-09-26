//
//  WearManageTblCell.swift
//  iGlasses
//
//  Created by fuhuayou on 2021/4/21.
//

import UIKit

// swiftlint:disable private_outlet
// swiftlint:disable prohibited_interface_builder
class WearManageTblCell: UITableViewCell {

    @IBOutlet weak var iSwitch: CustomSwitch!
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var bottomLine: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
