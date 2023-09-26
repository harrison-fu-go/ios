//
//  ViewController.swift
//  YYIOSPeripheral
//
//  Created by zk-fuhuayou on 2021/5/27.
//

import UIKit

class ViewController: UIViewController {
    var peripheralCentral:YYPeripheralCenter?
    override func viewDidLoad() {
        super.viewDidLoad()
        peripheralCentral = YYPeripheralCenter()
    }

    
    @IBAction func startBroadcast (_ sender: UIButton) {
        peripheralCentral?.startBroadCast()
    }

}

