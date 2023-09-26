//
//  ViewController.swift
//  AudioUnitDemo
//
//  Created by zk-fuhuayou on 2021/8/16.
//

import UIKit

class ViewController: UIViewController {

    var audioUnitCentr:YYAudioUnitCenter?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        audioUnitCentr = YYAudioUnitCenter()
    }

    
    @IBAction func click(_ button: UIButton) {
        if button.tag == 0 {
            audioUnitCentr?.start()
        } else {
            audioUnitCentr?.stop()
        }
    }

}

