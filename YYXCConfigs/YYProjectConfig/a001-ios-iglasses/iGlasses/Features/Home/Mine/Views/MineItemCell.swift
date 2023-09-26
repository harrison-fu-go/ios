//
//  MineItemCell.swift
//  iGlasses
//
//  Created by zk-fuhuayou on 2021/7/30.
//

import UIKit

enum MineItemType {
    case normal
    case withVersion
    case `switch`
}

class MineItemCell: UITableViewCell {
    
    @IBOutlet weak var icon:UIImageView!
    @IBOutlet weak var title:UILabel!
    @IBOutlet weak var version:UILabel!
    @IBOutlet weak var nextImageView:UIImageView!
    @IBOutlet weak var iSwith:CustomSwitch!
    @IBOutlet weak var baseLine:UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setContent(type: MineItemType, iIcon: String, iTitle: String, iVersion:String? = nil) {
        switch type {
        case .normal:
            version.isHidden = true
            iSwith.isHidden = true
            nextImageView.isHidden = false
        case .withVersion:
            version.isHidden = false
            iSwith.isHidden = true
            nextImageView.isHidden = false
        case .switch:
            version.isHidden = true
            iSwith.isHidden = false
            nextImageView.isHidden = true
        }
        icon.image = ImageAsset(name: iIcon).image
        title.text = iTitle
        if iVersion != nil {
            version.text = iVersion
        }
    }
    
    func hideBaseLine() {
        baseLine.isHidden = true
    }
}
