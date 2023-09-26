//
//  CustomGradualProgressBar.swift
//  iGlasses
//
//  Created by fuhuayou on 2021/4/27.
//

import UIKit
//swiftlint:disable force_unwrapping
class CustomGradualProgressBar: UIView {
    var gradualColors:[UIColor]?
    var bgColor: UIColor?
    var trackView: UIView?
    var trackBgView: UIView?
    var gradualLayer:CAGradientLayer?
    var isSet: Bool = false
    var setValue:Float = 0
    var isProgress = false
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.layer.cornerRadius = self.bounds.height / 2.0
        self.clipsToBounds = true
        //add trackBgView
        trackBgView = UIView(frame: self.bounds)
        trackBgView?.layer.cornerRadius = self.bounds.height / 2.0
        trackBgView?.clipsToBounds = true
        self.addSubview(trackBgView!)
        setSubViews()
        
        //add trackImageView
        trackView = UIView(frame: CGRect(x: self.bounds.minX, y: self.bounds.minY, width: 0, height: self.bounds.height))
        trackView?.layer.cornerRadius = self.bounds.height / 2.0
        trackView?.clipsToBounds = true
        self.addSubview(trackView!)
        
        setSubViews()
    }
    
    func setColors(graduals: [UIColor], bgColor: UIColor) {
        self.gradualColors = graduals
        self.bgColor = bgColor
        setSubViews()
    }
    
    func setSubViews() {
        if self.bgColor == nil || trackView == nil || isSet {
            return
        }
        isSet = true
        let layer = CAGradientLayer()
        gradualLayer = layer
        layer.frame = trackView!.bounds
        layer.colors = gradualColors!.map {
            $0.cgColor
        }
        layer.startPoint = CGPoint(x: 0, y: 0)
        layer.endPoint = CGPoint(x: 1, y: 0)
        trackView!.layer.addSublayer(layer)
        self.trackBgView?.backgroundColor = bgColor
    }
    
    func setProgressValue(val:Float, _ duration: Float = 0.5) {
        self.setValue = val
        if self.isProgress {
            return
        }
        self.isProgress = true
        DispatchQueue.main.asyncAfter(deadline:.now() + 0.1) {
            let W = self.bounds.width
            let pW:Float = self.setValue / 100 * Float(W)
            var newFrame = self.trackView!.frame
            newFrame = CGRect(x: newFrame.minX, y: newFrame.minY, width: CGFloat(pW), height: newFrame.height)
            UIView.animate(withDuration:Double(duration < 0.2 ? 0.2 : duration)) {
                self.gradualLayer?.frame = newFrame
                self.trackView?.frame = newFrame
                self.isProgress = false
            }
        }
    }
}
