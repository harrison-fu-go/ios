//
//  ViewController.swift
//  YYVideoAndAudio
//
//  Created by HarrisonFu on 2024/2/28.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        YYVideoCapture.share.initCapture()
    }


}

