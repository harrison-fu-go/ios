//
//  ViewController.swift
//  YYAlertViews
//
//  Created by HarrisonFu on 2024/4/1.
//

import UIKit
import SpriteKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let alertView = YYBaseAlertView.alert(title: "fhdhksfds",
                                                         content: "1.fdsfsjfjslf fdsjf fdsfjskfdsflds \n2. fdsfj je 和复合",
                                                         cancel: "cancel",
                                                         ok: "ok")
        self.view.addSubview(alertView)
        alertView.snp.makeConstraints { make in
            make.left.top.right.bottom.equalToSuperview()
        }
    }
}

