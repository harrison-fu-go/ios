//
//  YYChartVC.swift
//  YYSwiftLearning
//
//  Created by HarrisonFu on 2023/4/19.
//

import UIKit

class YYChartVC: UIViewController {
    var sW = UIScreen.main.bounds.width
    var sH = UIScreen.main.bounds.height
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        let eq = NTEQPath(frame: CGRect(x: 0, y: 100, width:sW , height: 200))
        self.view.addSubview(eq)
    }

}
