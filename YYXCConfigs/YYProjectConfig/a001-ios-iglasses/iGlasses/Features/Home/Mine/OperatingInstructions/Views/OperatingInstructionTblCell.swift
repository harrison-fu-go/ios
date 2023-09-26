//
//  OperatingInstructionTblCell.swift
//  iGlasses
//
//  Created by fuhuayou on 2021/4/21.
//

import UIKit

// swiftlint:disable private_outlet
// swiftlint:disable prohibited_interface_builder
class OperatingInstructionTblCell: UITableViewCell {
    
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    @IBOutlet weak var bottomLine: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //init code.
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
