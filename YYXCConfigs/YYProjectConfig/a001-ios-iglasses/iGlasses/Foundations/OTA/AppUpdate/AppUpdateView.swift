//
//  AppUpdateView.swift
//  iGlasses
//
//  Created by zk-fuhuayou on 2021/5/17.
//

import UIKit

class AppUpdateView: UIView {
    static func popUp(content: AppVersion?, callback:@escaping (() -> Void)) {
        let window = UIApplication.shared.windows.first
        if let window = window {
            let view = AppUpdateView(frame: window.bounds, content: content)
            view.finishedCallback = callback
            window.addSubview(view)
        }
    }
    var content: AppVersion?
    var finishedCallback: (() -> Void)?
    @IBOutlet var contentView:UIView?
    @IBOutlet var textView: UITextView?
    @IBOutlet var valueView:UIView?
    @IBOutlet var newVersionLable:UILabel?
    @IBOutlet var cancelBtn:UIButton?
    @IBOutlet var cancelImageView:UIImageView?
    
    @IBAction func cancelUpdate(_ sender:UIButton) {
        finishedCallback?()
        self.removeFromSuperview()
    }
    
    @IBAction func gotoUpdate(_ sender:UIButton) {
        if let content = self.content {
            if UIApplication.shared.canOpenURL(content.linkAppStore) {
                UIApplication.shared.open(content.linkAppStore)
            }
        }
    }

    override func draw(_ rect: CGRect) {
        if let valueView = self.valueView {
            let cornerLayer = CAShapeLayer()
            cornerLayer.path = UIBezierPath(roundedRect:valueView.bounds,
                                            byRoundingCorners:  [.bottomLeft, .bottomRight],
                                            cornerRadii: CGSize(width: 8, height: 8)).cgPath
            valueView.layer.mask = cornerLayer
            valueView.layer.masksToBounds = true
            valueView.clipsToBounds = true
        }
    }
 
    let cellIdentifier = "AppUpdateViewTableCell"
    var titles = [String]()
    var isInit: Bool = false
    init(frame: CGRect, content: AppVersion?) {
        super.init(frame: frame)
        self.content = content
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initView()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initView()
    }
    
    //swiftlint:disable force_unwrapping
    func initView() {
        if isInit {
            return
        }
        isInit = true
        Bundle.main.loadNibNamed("AppUpdateView", owner:self, options:nil)
        self.addSubview(contentView!)
        contentView?.snp.makeConstraints { make in
            make.left.right.bottom.top.equalToSuperview()
        }
        
        if let content = self.content {
            self.newVersionLable?.text = "V" + content.latestVersion
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 4
            let attributes: [NSAttributedString.Key : Any] = [
                NSAttributedString.Key.paragraphStyle : paragraphStyle,
                NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)]
            self.textView?.attributedText = NSAttributedString(string: content.updateDesc, attributes: attributes)
            self.textView?.textColor = UIColor(hex: 0x333333)
            if content.forceUpdate {
                cancelBtn?.isHidden = true
                cancelImageView?.isHidden = true
            }
        }
    }
}
