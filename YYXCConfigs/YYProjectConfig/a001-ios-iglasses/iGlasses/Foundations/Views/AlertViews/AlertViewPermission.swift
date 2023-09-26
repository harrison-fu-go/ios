//
//  AlertViewPermission.swift
//  iGlasses
//
//  Created by zk-fuhuayou on 2021/5/26.
//

import UIKit

class AlertViewPermission: UIView {
    
    static func popUp(message:[String:String]? = nil, callback: (() -> Void)? = nil) {
        let window = UIApplication.shared.windows.first
        if let window = window {
            let view = AlertViewPermission(frame: window.bounds, content: message)
            view.finishedCallback = callback
            window.addSubview(view)
        }
    }
    
    @IBOutlet var contentView:UIView?
    @IBOutlet var titleLabel:UILabel?
    @IBOutlet var messageLabel:UILabel?
    
    @IBAction func ok(_ sender:UIButton) {
        self.removeFromSuperview()
        self.finishedCallback?()
    }
    
    var content:[String:String]?
    var finishedCallback: (() -> Void)?
    init(frame: CGRect, content: [String:String]?) {
        super.init(frame: frame)
        self.content = content
        self.initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initView()
    }
    
    func initView() {
        Bundle.main.loadNibNamed("AlertViewPermission", owner:self, options:nil)
        guard let conView = contentView else {
            return
        }
        self.addSubview(conView)
        conView.snp.makeConstraints { make in
            make.left.right.bottom.top.equalToSuperview()
        }
        
        guard let iContent = content else {
            return
        }
        let title = iContent["title"]
        let mess = iContent["message"]
        self.titleLabel?.text = title ?? ""
        self.messageLabel?.text = mess ?? ""
    }
}
