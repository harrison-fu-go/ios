//
//  CustomSwitch.swift
//  iGlasses
//
//  Created by fuhuayou on 2021/4/25.
//

import UIKit
//swiftlint:disable force_unwrapping
//swiftlint:disable explicit_init
//swiftlint:disable attributes
class CustomSwitch: UIView {
    var selectedBackgroundImageView: UIImageView?
    var tapImageView: UIImageView?
    var selectedTapImageView: UIImageView?
    
    var isSliding = false
    var isSelected = false
    var stateBlock: ((Bool) -> Void)?
    func initViews() {
        //set style.
        let frame = self.bounds
        self.layer.cornerRadius = frame.height / 2.0
        self.clipsToBounds = true
        
        //add background
        let bgImageView = UIImageView(image:Asset.Connection.switchesOffBackground.image)
        bgImageView.frame = self.bounds
        self.addSubview(bgImageView)
        
        //add selected image view.
        selectedBackgroundImageView = UIImageView(image: Asset.Connection.switchesOnBackground.image)
        selectedBackgroundImageView?.frame = self.bounds

        //add default tap.
        tapImageView = UIImageView(image: Asset.Connection.switchesOffButton.image)
        tapImageView?.frame = CGRect(x:0, y: 0, width:self.bounds.height, height:self.bounds.height)
        tapImageView?.contentMode = .scaleAspectFit
        self.addSubview(tapImageView!)
    }

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        initViews()
        //添加手势
        let tap = UITapGestureRecognizer.init(target:self, action: #selector(tapView))
        self.addGestureRecognizer(tap)
    }
    
    func addStateBlock(handle: @escaping ((Bool) -> Void)) {
        self.stateBlock = handle
    }
    
    func stateDidChange() {
        if let handle = self.stateBlock {
            handle(self.isSelected)
        }
    }
    
    func enableSwith(isEnable: Bool) {
        if isEnable != self.isSelected {
            tapView(isAuto: true)
        }
    }
    
    @objc func tapView(isAuto: Bool = false) {
        
        if isSliding {
            return
        }
        isSliding = true
        let W = self.bounds.width
        let H = self.bounds.height
        if !isSelected {
            //add selected view.
            self.selectedBackgroundImageView?.alpha = 1.0
            selectedBackgroundImageView?.frame = CGRect(x: (H + 1) - W, y: 0, width: W, height: H)
            self.insertSubview(selectedBackgroundImageView!, belowSubview:tapImageView!)
            
            //move.
            UIView.animate(withDuration: 0.2) {
                self.selectedBackgroundImageView?.frame = CGRect(x:0, y: 0, width: W, height: H)
                self.tapImageView?.frame = CGRect(x: W - H, y: 0.0, width: H, height: H)
            } completion: { success in
                if success {
                    self.tapImageView?.image = Asset.Connection.switchesOnButton.image
                    self.isSliding = false
                    self.isSelected = true
                    if !isAuto {
                        self.stateDidChange()
                    }
                }
            }
            
        } else {

            UIView.animate(withDuration: 0.2) {
                self.tapImageView?.frame = CGRect(x:0, y: 0, width: H, height: H)
            } completion: { _ in
                self.tapImageView?.frame = CGRect(x:0, y: 0, width: H, height: H)
                self.tapImageView?.image = Asset.Connection.switchesOffButton.image
            }
            
            //move.
            UIView.animate(withDuration: 0.23) {
                self.selectedBackgroundImageView?.frame = CGRect(x: 0, y: 0, width: W, height: H)
                self.selectedBackgroundImageView?.alpha = 0.0
            } completion: { _ in
                self.selectedBackgroundImageView?.removeFromSuperview()
                self.isSliding = false
                self.isSelected = false
                if !isAuto {
                    self.stateDidChange()
                }
            }
        }
    }
}
