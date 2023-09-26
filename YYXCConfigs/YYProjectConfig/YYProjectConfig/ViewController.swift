//
//  ViewController.swift
//  YYProjectConfig
//
//  Created by HarrisonFu on 2023/2/15.
//

import UIKit
import DeviceGuru
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            let version: String? = try? Configuration.value(for: "API_BASE_URL")
            debugPrint("========\(version ?? "error")")
            let deviceInfo = DeviceGuruImplementation()
            debugPrint("========\(deviceInfo.hardware)")
        }
    }
}

