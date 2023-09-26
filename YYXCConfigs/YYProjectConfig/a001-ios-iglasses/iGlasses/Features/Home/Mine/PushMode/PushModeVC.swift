//
//  PushModeVC.swift
//  iGlasses
//
//  Created by zk-fuhuayou on 2021/8/10.
//

import UIKit

class PushModeVC: UIViewController {
    let viewModel:PushModeViewModel
    @IBOutlet var naviBar: HoloeverHeaderTitleSearchView! {
        didSet {
            naviBar.titleLable.text = "推送模式"
            naviBar.enableSearch(isEnable: false)
        }
    }

    @IBOutlet var radioImages: [UIImageView]!
    
    init(viewModel: PushModeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        didSelectMode(nil)
    }
    
    @IBAction func didSelectMode(_ sender: UIButton?) {
        let sTag = sender?.tag ?? 0
        for imageView in radioImages {
            imageView.isHighlighted = imageView.tag == sTag
        }
    }

}
