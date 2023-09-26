//
//  IconTitleRightArrowTblCell.swift
//  iGlasses
//
//  Created by fuhuayou on 2021/4/26.
//

import UIKit

class IconTitleRightArrowTblCell: UITableViewCell {
    
    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setTitleAndImage(title:String, image:String) {
        self.titleLabel.text = title
        self.iconImageView.image = UIImage(named: image)
    }
    
}
