//
//  StringResearchVC.swift
//  YYSwiftLearning
//
//  Created by HarrisonFu on 2024/2/18.
//

import UIKit

class StringResearchVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        var empty: String  = ""
        print("empty:  \(empty)")
        print(withUnsafePointer(to: &empty, { $0 }))
    }

}
