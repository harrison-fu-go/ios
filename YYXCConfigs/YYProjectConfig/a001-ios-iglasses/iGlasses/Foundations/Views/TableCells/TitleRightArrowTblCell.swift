//
//  TitleRightArrowTblCell.swift
//  iGlasses
//
//  Created by fuhuayou on 2021/4/26.
//

import UIKit

class TitleRightArrowTblCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setTitle(title:String) {
        self.titleLabel.text = title
    }
    
    
}
