//
//  HoloeverHeaderView.swift
//  iGlasses
//
//  Created by fuhuayou on 2021/4/22.
//

import UIKit

class HoloeverHeaderView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet var menuContainer: UIButton!
    var isInit: Bool = false
    var menuBlock: (() -> Void)?
    override init(frame: CGRect) {
        super.init(frame: frame)
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
    
    func initView() {
        if isInit {
            return
        }
        isInit = true
        Bundle.main.loadNibNamed("HoloeverHeaderView", owner:self, options:nil)
        self.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.left.right.bottom.top.equalToSuperview()
        }
    }
    
    // set menu container enable/disable. default is  disable.
    func enableMenu(isEnable: Bool) {
        self.menuContainer.isHidden = !isEnable
    }
    
    //swiftlint:disable force_cast
    @IBAction func didTapMenu(_ sender: Any) {
        let button = sender as! UIButton
        UIView.animate(withDuration: 0.1) {
            button.alpha = 0.5
        } completion: { _ in
            
            if let block = self.menuBlock {
                block()
            } 
            
            UIView.animate(withDuration: 0.1) {
                button.alpha = 1.0
            }
        }

    }
    
}
