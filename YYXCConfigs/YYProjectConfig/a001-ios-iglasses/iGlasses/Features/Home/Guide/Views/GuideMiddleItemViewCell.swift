//
//  GuideBottomItemViewCell.swift
//  iGlasses
//
//  Created by xian punan on 2021/4/30.
//

import UIKit
import Kingfisher

class GuideMiddleItemViewCell: UITableViewCell {
    static let cellIdentifier = "GuideMiddleItemViewCell"
    
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var headerImage: UIImageView! {
        didSet {
            headerImage.layer.cornerRadius = 4.0
            headerImage.clipsToBounds = true
        }
    }
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var shadowView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private var alreadyAddShadow = false
    
    
    func addShadow(bounds: CGRect) {
        if alreadyAddShadow {
            return
        }
        let shadowBounds = CGRect(x: 0, y: -5, width: bounds.width - 40, height: bounds.height + 5)
        let shadowLayer = CAShapeLayer()
        
        shadowLayer.path = UIBezierPath(rect: shadowBounds).cgPath
        shadowLayer.shadowColor = UIColor(hex: 0x0056A7).cgColor
        shadowLayer.shadowOffset = CGSize(width: 0.5, height:3)
        shadowLayer.shadowOpacity = 0.3
        self.shadowView.layer.insertSublayer(shadowLayer, at: 0)
        alreadyAddShadow = true
        
    }
    
    func updateViewData(_ news: GuideNews) {
        self.titleLabel.text = news.title
        self.subTitleLabel.text = news.summary
        self.headerImage.kf.setImage(with: news.image, placeholder: Asset.PlaceHolder.guideSmallLoadingPlaceHolder.image)
    }
}
