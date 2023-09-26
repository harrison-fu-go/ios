//
//  YYCSVVC.swift
//  YYSwiftLearning
//
//  Created by HarrisonFu on 2023/9/14.
//

import UIKit

class YYCSVVC: UIViewController {
    let csvCenter: NTCSVCenter = NTCSVCenter(inFolder: "csvtest.2")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        let button = UIButton()
        self.view.addSubview(button)
        button.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalToSuperview().offset(100)
            make.width.equalTo(180)
            make.height.equalTo(50)
        }
        button.backgroundColor = .black
        button.setTitle("Test CSV", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.addTarget(self, action: #selector(onTapTest(_:)), for: .touchUpInside)
        
        
        let stopButton = UIButton()
        self.view.addSubview(stopButton)
        stopButton.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalToSuperview().offset(200)
            make.width.equalTo(180)
            make.height.equalTo(50)
        }
        stopButton.backgroundColor = .black
        stopButton.setTitle("Stop CSV", for: .normal)
        stopButton.setTitleColor(.red, for: .normal)
        stopButton.addTarget(self, action: #selector(onStopTest(_:)), for: .touchUpInside)
    }
    

    @objc func onTapTest(_ sender: Any) {
        let success = self.csvCenter.startStreamSave(toFile: "test3", headers: ["name", "age", "email"])
        if success {
            for i in 0..<100 {
                let data = [
                    ["fsfs", "\(i)", "john@example.com"],
                    ["Alice", "\(i)", "alice@example.com"],
                    ["fdsfds", "\(i)", "bob@example.com"]
                ]
                let success = self.csvCenter.streamSave(datas: data)
                print("=== NTCSVCenter: save ==== \(success)")
            }
        }
    }
    
    @objc func onStopTest(_ sender: Any) {
        self.csvCenter.streamStop()
    }
}
