//
//  ViewController.swift
//  YYRadarChart
//
//  Created by HarrisonFu on 2022/5/3.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        let radaView = YYRadarChart(frame: CGRect(x: 0, y: 100, width: UIScreen.main.bounds.width, height: 400))
        view.addSubview(radaView)
        // Do any additional setup after loading the view.
    }


}

