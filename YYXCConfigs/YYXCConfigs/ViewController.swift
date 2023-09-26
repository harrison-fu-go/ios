//
//  ViewController.swift
//  YYXCConfigs
//
//  Created by HarrisonFu on 2023/2/20.
//

import UIKit
import DeviceGuru
class ViewController: UIViewController {
    
    
    @IBOutlet var label: UILabel?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            let version: String = (try? Configuration.value(for: "API_BASE_URL")) ?? "error"
            debugPrint("========\(version)")
            let deviceInfo = DeviceGuruImplementation()
            debugPrint("========\(deviceInfo.hardware)")
            
            self.label?.text = version
        }
    }


}

