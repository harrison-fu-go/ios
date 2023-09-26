//
//  GuideTopItemViewCell.swift
//  iGlasses
//
//  Created by xian punan on 2021/4/30.
//

import UIKit
import SnapKit

class GuideTopItemViewCell: UITableViewCell {
    static let cellIdentifier = "GuideTopItemViewCell"

    @IBOutlet weak var container: UIView!
    @IBOutlet weak var bgImage: UIImageView!
    @IBOutlet weak var titlelabel: UILabel!
//    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    private var alreadyAddCornerShadow = false
    
//    override var frame: CGRect {
//        set {
//            var _frame = newValue
//            _frame.origin.x = 20
//            _frame.size.width -= 40
//            super.frame = _frame
//        }
//        get {
//            return super.frame
//        }
//    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    func setTopCorner(bounds _bounds: CGRect) {
        if alreadyAddCornerShadow {
           return
        }
        // 添加阴影
        let shadowBounds = CGRect(x: 20, y: 0, width: _bounds.width - 40, height: _bounds.height)
        let shadowLayer = CAShapeLayer()
        shadowLayer.path = UIBezierPath(roundedRect:shadowBounds,
                                      byRoundingCorners:  [.topLeft, .topRight],
                                      cornerRadii: CGSize(width: 8, height: 8)).cgPath
        shadowLayer.shadowColor = UIColor(hex: 0x0056A7).cgColor
        shadowLayer.shadowOffset = CGSize(width:0.8, height: 3)
        shadowLayer.shadowOpacity = 0.3
        self.container.layer.insertSublayer(shadowLayer, at: 0)
        
        // 添加圆角
        let cornerLayer = CAShapeLayer()
        let cornerBounds = CGRect(x: 0, y: 0, width: _bounds.width - 40, height: _bounds.height)
        cornerLayer.path = UIBezierPath(roundedRect:cornerBounds,
                                        byRoundingCorners:  [.topLeft, .topRight],
                                        cornerRadii: CGSize(width: 8, height: 8)).cgPath
        self.bgImage.layer.mask = cornerLayer
        self.bgImage.layer.masksToBounds = true
        
        alreadyAddCornerShadow = true
    }
    
    func updateViewData(_ news: GuideNews) {
        self.titlelabel.text = news.title
        self.bgImage.kf.setImage(with: news.image, placeholder: Asset.PlaceHolder.guideBigLoadingPlaceHolder.image)
    }
}
