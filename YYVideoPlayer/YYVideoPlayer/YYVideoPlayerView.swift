//
//  YYVideoPlayerView.swift
//  YYVideoPlayerView
//
//  Created by HarrisonFu on 2022/8/30.
//

import Foundation
import AVKit
import GPUImage
import UIKit
public class YYVideoPlayerView: UIView {
    
    lazy var movie: GPUImageMovie = {
          let movie = GPUImageMovie()
          movie.yuvConversionSetup()
          movie.addTarget(imageView)
          return movie
      }()
      
      lazy var imageView: GPUImageView = {
          let view = GPUImageView()
          view.setBackgroundColorRed(1, green: 1, blue: 1, alpha: 1)
          return view
      }()
    
    var playerItem: AVPlayerItem?
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    var url: URL?
    var rate:Float = 1.0
    func loadVideo(url:String,
                   rate:Float = 1.0,
                   repeatPlay:Bool = true,
                   cravity:AVLayerVideoGravity = .resizeAspectFill) {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(willEnterForground),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)
        loadPlayer(url: url, rate: rate, repeatPlay: repeatPlay, cravity: cravity)
        if let playerLayer = playerLayer {
            self.layer.addSublayer(playerLayer)
        }
        self.addSubview(self.imageView)
        if repeatPlay {
            self.setRepeatPlay()
        }
    }
    
    @objc func willEnterForground(_ notify: NSNotification) {
        self.play()
    }
    
    func play() {
        if let playerLayer = playerLayer {
            imageView.frame = playerLayer.bounds
        }
        movie.endProcessing()
        movie.playerItem = self.playerItem
        self.player?.play()
        movie.startProcessing()
    }
    
    func pause() {
        self.player?.pause()
    }
    
    func setRepeatPlay() {
        self.player?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1.0, preferredTimescale: CMTimeScale(1.0)),
                                             queue: DispatchQueue.main,
                                             using: {[weak self] time in
            guard let playerItem = self?.playerItem else {
                return
            }
            let current = CMTimeGetSeconds(time)
            let total = CMTimeGetSeconds(playerItem.duration)
            if current == .nan || total == .nan {
                return
            }
//            print("=========== curren:\(current) total:\(total) === ")
            if current == total {
                if let url = self?.url {
                    self?.player?.pause()
                    self?.movie.endProcessing()
                    self?.playerItem = AVPlayerItem(url: url)
                    self?.movie.playerItem = self?.playerItem
                    self?.player?.replaceCurrentItem(with: self?.playerItem)
                    self?.player?.play()
                    self?.movie.startProcessing()
                }
            }
        })
    }
    
    func loadPlayer(url:String,
                    rate:Float = 1.0,
                    repeatPlay:Bool = true,
                    cravity:AVLayerVideoGravity = .resizeAspectFill) {
        guard let nsurl = NSURL(string: url) as? URL else {
            return
        }
        self.url = nsurl
        self.rate = rate
        self.playerItem = AVPlayerItem(url: nsurl)
        self.player = AVPlayer.init(playerItem: self.playerItem)
        self.player?.rate = rate
        self.playerLayer = AVPlayerLayer.init(player: self.player)
        self.playerLayer?.videoGravity = cravity
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.imageView.frame = self.bounds
        self.playerLayer?.frame = self.bounds
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

