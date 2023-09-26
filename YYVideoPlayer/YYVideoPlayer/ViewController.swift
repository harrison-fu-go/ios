//
//  ViewController.swift
//  YYVideoPlayer
//
//  Created by HarrisonFu on 2022/8/30.
//

import UIKit
class ViewController: UIViewController {
    var player : YYVideoPlayerView?
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("Remove", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.addTarget(self, action: #selector(endAction(_:)), for: .touchUpInside)
        button.frame = CGRect(x: (UIScreen.main.bounds.width - 200.0) / 2.0, y: UIScreen.main.bounds.height - 80, width: 200, height: 48)
        button.clipsToBounds = true
        button.layer.cornerRadius = 24.0
        button.layer.borderColor = UIColor.red.cgColor
        button.layer.borderWidth = 2.0
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(button)
        self.load()
        self.view.addSubview(button)
    }
    
    @objc func endAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            self.remove()
            sender.setTitle("Load", for: .normal)
        } else {
            self.load()
            sender.setTitle("Remove", for: .normal)
        }
    }
    
    func load() {
        let url = Bundle.main.url(forResource: "jv", withExtension: "mp4")
        if let url = url?.absoluteString as? String {
            self.player = YYVideoPlayerView(frame: self.view.bounds)
            if let player = player {
                self.view.insertSubview(player, at: 0)
                player.loadVideo(url: url)
                player.play()
            }
        }
    }
    
    func remove() {
        self.player?.pause()
        self.player?.removeFromSuperview()
        self.player = nil
    }
}

