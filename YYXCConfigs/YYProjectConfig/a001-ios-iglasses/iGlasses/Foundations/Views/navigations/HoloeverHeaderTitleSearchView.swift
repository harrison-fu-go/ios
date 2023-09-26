//
//  HoloeverHeaderTitleSearchView.swift
//  iGlasses
//
//  Created by fuhuayou on 2021/4/25.
//

import UIKit

class HoloeverHeaderTitleSearchView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet var saveButton: UIButton! {
        didSet {
            saveButton.layer.cornerRadius = 2.0
            saveButton.clipsToBounds = true
        }
    }
    var isSaveEnable = false
    @IBOutlet var titleLable: UILabel!
    @IBOutlet var backBtn: UIButton!
    var isInit: Bool = false
    var saveBlock:(() -> Void)?
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
        Bundle.main.loadNibNamed("HoloeverHeaderTitleSearchView", owner:self, options:nil)
        self.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.left.right.bottom.top.equalToSuperview()
        }
    }
    
    // set menu container enable/disable. default is  disable.
    func enableSearch(isEnable: Bool) {
        self.saveButton.isHidden = !isEnable
    }
    
    func setNavigationTitle(title: String, _ enableSearch: Bool = true) {
        self.titleLable.text = title
        self.saveButton.isHidden = !enableSearch
    }
    
    @IBAction func didTapBack (_ sender: Any) {
        let nc = getNavigationController()
        if let nc = nc {
            nc.popViewController(animated: true)
        }
    }
    
    @IBAction func onSave (_ sender: Any) {
        if !isSaveEnable {
            return
        }
        self.saveBlock?()
    }
    
    func getNavigationController() -> UINavigationController? {
        var n = next
        while n != nil {
            if n is UINavigationController {
                return n as? UINavigationController
            }
            n = n?.next
        }
        return nil
    }
    
    func changeSaveState(enable: Bool) {
        saveButton.backgroundColor = enable ? UIColor(hex: 0x1990FF) : UIColor(hex: 0xE2E2E2)
        saveButton.setTitleColor(enable ? UIColor(hex: 0xFFFFFF) : UIColor(hex: 0xBFBFBF), for: .normal)
        saveButton.layer.cornerRadius = enable ? 4.0 : 2.0
        saveButton.clipsToBounds = true
        isSaveEnable = enable
    }
    
    func addSaveBlock(saveBlock: @escaping () -> Void) {
        self.saveBlock = saveBlock
    }
}
