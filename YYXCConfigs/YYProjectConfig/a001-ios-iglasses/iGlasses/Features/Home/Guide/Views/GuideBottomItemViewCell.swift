//
//  GuideBottomItemViewCell.swift
//  iGlasses
//
//  Created by xian punan on 2021/4/30.
//

import UIKit

class GuideBottomItemViewCell: UITableViewCell {
    static let cellIdentifier = "GuideBottomItemViewCell"
    
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
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    private var alreadyAddCornerShadow = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setBottomCorner(bounds _bounds: CGRect) {
        if alreadyAddCornerShadow {
            return
        }
        let cornerLayer = CAShapeLayer()
        let cornerBounds = CGRect(x: 0, y: 0, width: _bounds.width - 40, height: _bounds.height - bottomConstraint.constant)
        cornerLayer.path = UIBezierPath(roundedRect:cornerBounds,
                                        byRoundingCorners:  [.bottomLeft, .bottomRight],
                                        cornerRadii: CGSize(width: 8, height: 8)).cgPath
        self.container.layer.mask = cornerLayer
        self.container.layer.masksToBounds = true
        addShadow(bounds: _bounds)
        alreadyAddCornerShadow = true
    }

    func addShadow(bounds: CGRect) {
        let shadowBounds = CGRect(x: 0, y: -5, width: bounds.width - 40, height: bounds.height - bottomConstraint.constant + 5)
        let shadowLayer = CAShapeLayer()
        
        shadowLayer.path = UIBezierPath(roundedRect:shadowBounds,
                                        byRoundingCorners:  [.bottomLeft, .bottomRight],
                                        cornerRadii: CGSize(width: 8, height: 8)).cgPath
        shadowLayer.shadowColor = UIColor(hex: 0x0056A7).cgColor
        shadowLayer.shadowOffset = CGSize(width: 0.5, height: 2)
        shadowLayer.shadowOpacity = 0.3
        self.shadowView.layer.insertSublayer(shadowLayer, at: 0)
    }
    
    func updateViewData(_ news: GuideNews) {
        self.titleLabel.text = news.title
        self.subTitleLabel.text = news.summary
        self.headerImage.kf.setImage(with: news.image, placeholder: Asset.PlaceHolder.guideSmallLoadingPlaceHolder.image)
    }
}
