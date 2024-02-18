//
//  ViewController.swift
//  YYTextEvents
//
//  Created by HarrisonFu on 2024/1/23.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        let text = "user_china_privacy_hint".paramLocalized(
//            args: "user_agreement".localized,
//            "permission_usage_instructions".localized,
//            "personal_Information_Instructions".localized,
//            "privacy_notice_title".localized
//        )
        var text = "user_china_privacy_hint".localized
        text = text.replacingOccurrences(of: "[%1$s]", with: "user_agreement".localized)
        text = text.replacingOccurrences(of: "[%2$s]", with: "permission_usage_instructions".localized)
        text = text.replacingOccurrences(of: "[%3$s]", with: "personal_Information_Instructions".localized)
        text = text.replacingOccurrences(of: "[%4$s]", with: "privacy_notice_title".localized)
        
        let subUnderLines = [
            "user_agreement".localized,
            "permission_usage_instructions".localized,
            "personal_Information_Instructions".localized,
            "privacy_notice_title".localized
        ]
        
        let label = NTTapLabel(txt: text, underLines: subUnderLines)
        self.view.addSubview(label)
        label.onTapCallback = { txt in
            debugPrint("========= \(txt)")
        }
    }


}

