//
//  ZKTimer.swift
//  YYBLEDemo1
//
//  Created by fuhuayou on 2021/4/14.
//
import UIKit

class ZKTimer: NSObject {
    
    var timeout: Double?
    var isRepeat: Bool?
    var timer: DispatchSourceTimer?
    let tQueue = DispatchQueue(label: "ZKTimer")
    init(interval:Double, repeats:Bool, block:((ZKTimer?) -> Void )? ) {
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
    
    static func timer(interval:Double, repeats:Bool, block:((ZKTimer?) -> Void )? ) {
        _ = ZKTimer(interval: interval, repeats: repeats, block: block)
    }
    
    func invalidate() {
        if let timer = self.timer {
            timer.cancel()
        }
        self.timer = nil
    }
}
