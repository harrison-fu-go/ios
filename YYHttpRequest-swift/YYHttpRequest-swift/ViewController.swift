//
//  ViewController.swift
//  YYHttpRequest-swift
//
//  Created by HarrisonFu on 2024/2/19.
//

import UIKit

class ViewController: UIViewController {
    
    @IBAction func onTapRequest(_ sender: Any) {
        // Do any additional setup after loading the view.
//        let status = URLSession.shared.configuration.allowsCellularAccess
//        if status == true {
//            let url = "https://jsonplaceholder.typicode.com/posts"
//            YYHttpRequest.request(url: url, method: .get) { result in
//                print("============ \(result)")
//            }
//        } else {
//            // 没有网络访问权限
//        }
        

        /**
         https://reqres.in 这个网站可以测试POST.
         只有在上面测试了： email 才可以返回 成功。
         */
        let url = "https://reqres.in/api/register"
        YYCustomHttpsRequest.request(httpMethod: .POST, urlStr: url, parameters: [
            "email": "eve.holt@reqres.in",
            "password": "pistol"
        ])
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

