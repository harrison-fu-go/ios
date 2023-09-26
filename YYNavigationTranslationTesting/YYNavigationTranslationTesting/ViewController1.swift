//
//  ViewController1.swift
//  YYNavigationTranslationTesting
//
//  Created by HarrisonFu on 2022/7/6.
//

import UIKit

class ViewController1: UIViewController {

    @IBOutlet var btn:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    @IBAction func onClick(_ sender: UIButton) {
//        self.dismiss(animated: true)
        let rect = self.btn.frame
        let newRect = CGRect(x: rect.minX, y: rect.minY - 300, width: rect.width, height: rect.height   )
        UIView.animate(withDuration: 4) {
            self.btn.frame = newRect
        } completion: { _ in
            
        }

        
    }
}
