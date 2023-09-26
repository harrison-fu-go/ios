//
//  TitleSwitchCustomView.swift
//  iGlasses
//
//  Created by zk-fuhuayou on 2021/8/10.
//

import UIKit

class TitleSwitchCustomView: UIView {
    
    @IBOutlet var contentView:UIView!
    @IBOutlet var iSwitch:CustomSwitch!
    var switchBlock:((Bool) -> Void)?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initView()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.initView()
    }
    
    func initView() {
        Bundle.main.loadNibNamed("TitleSwitchCustomView", owner:self, options:nil)
        guard let conView = contentView else {
            return
        }
        self.addSubview(conView)
        conView.snp.makeConstraints { make in
            make.left.right.bottom.top.equalToSuperview()
        }
        
        iSwitch.addStateBlock { state in
            self.switchBlock?(state)
        }
    }
    
    func enableSwitch(enable: Bool) {
        iSwitch.enableSwith(isEnable: enable)
    }
}
