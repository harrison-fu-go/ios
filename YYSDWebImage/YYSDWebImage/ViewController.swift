//
//  ViewController.swift
//  YYSDWebImage
//
//  Created by HarrisonFu on 2023/10/8.
//

import UIKit
import SDWebImage

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //测试图片
        let url = "https://images.pexels.com/photos/5372613/pexels-photo-5372613.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"
        let imgView = UIImageView(frame: CGRect(x: 100, y: 100, width: 200, height: 300))
//        imgView.sd_setImage(with: URL(string: url)) {a,b,c,d in
//            debugPrint("===== \(String(describing: a)), ===== \(b), ===== \(c), ===== \(d)")
//        }
        self.view.addSubview(imgView)
        imgView.sd_setImage(with: URL(string: url), placeholderImage: nil) { a, b, c in
            debugPrint("===== \(String(describing: a)), ===== \(b), ===== \(c)")
        }
        
    }
    
   
}

