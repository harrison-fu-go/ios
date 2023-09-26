//
//  IconTextSwitchTableCell.swift
//  iGlasses
//
//  Created by zk-fuhuayou on 2021/8/10.
//

import UIKit

class IconTextSwitchTableCell: UITableViewCell {

    @IBOutlet weak var icon:UIImageView!
    @IBOutlet weak var title:UILabel!
    @IBOutlet weak var iSwith:CustomSwitch!
    @IBOutlet weak var baseLine:UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setContent(iIcon: UIImage, iTitle: String, switchOn:Bool, hideBaseLine: Bool = false) {
        icon.image = iIcon
        title.text = iTitle
        baseLine.isHidden = hideBaseLine
        iSwith.enableSwith(isEnable: switchOn)
    }
}
