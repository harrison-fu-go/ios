//
//  NTTimer.swift
//  Alamofire
//
//  Created by HarrisonFu on 2022/4/20.
//

import Foundation

public class YYTimer : NSObject {
    
    var timeout: Double?
    var isRepeat: Bool?
    var timer: DispatchSourceTimer?
    let tQueue = DispatchQueue(label: "YYTimer")
    public init(interval:Double, repeats:Bool, block:((YYTimer?) -> Void )? ) {
        super.init()
        self.timer = DispatchSource.makeTimerSource(flags:[], queue: tQueue)
        if repeats == false {
            self.timer?.schedule(wallDeadline: .now() + interval, leeway: .milliseconds(10))
        } else {
            self.timer?.schedule(wallDeadline: .now() + interval, repeating: interval, leeway: .milliseconds(10))
        }
        self.timer?.setEventHandler(handler: {
            DispatchQueue.main.sync {
                
                if let block = block {
                    block(self)
                }
                
                if repeats == false {
                    self.invalidate()
                }
            }
        })
        self.timer?.resume()
        self.isRepeat = repeats
        self.timeout = interval
    }
    
    public static func timer(interval:Double, repeats:Bool, block:((YYTimer?) -> Void )? ) {
        _ = YYTimer(interval: interval, repeats: repeats, block: block)
    }
    
    public func invalidate() {
        if let timer = self.timer {
            timer.cancel()
        }
        self.timer = nil
    }
}
