//
//  ViewController.swift
//  YYAnimaton
//
//  Created by HarrisonFu on 2022/9/14.
//


/**
 关于锚点的变化：
    定义锚点可以确定，放大，缩小，的位置的时候，锚点的位置不变
 */

import UIKit
class ViewController: UIViewController, CAAnimationDelegate {
    var imageView = UIImageView()
    let animation = CABasicAnimation(keyPath: "position")
    var isEnable: Bool = false
    func centerX(w: Double) -> Double {
        return (UIScreen.main.bounds.size.width - w) / 2.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setImage()
        self.doRerun(self)
    }
    
    func setImage() {
        imageView.removeFromSuperview()
        imageView = UIImageView(image: UIImage(named: "ImageDemo"))
        imageView.frame = CGRect(x: centerX(w: 361), y: 208, width: 361, height: 426)
        self.view.addSubview(imageView)
        
        //refer view.
        let referView = UIView(frame: imageView.frame)
        referView.layer.borderWidth = 1.0
        referView.layer.borderColor = UIColor.red.cgColor
        self.view.addSubview(referView)
        
        self.drawPoint(rect: CGRect(x: centerX(w: 20), y: referView.frame.minY + (referView.frame.height - 20)/2.0, width: 20, height: 20))
        
        //设置变换的锚点CGPoint(x: 111.0/361.0, y: 265/426.0)
        self.drawPoint(rect: CGRect(x: referView.frame.minX + 111 - 10, y: referView.frame.minY + 265 - 10, width: 20, height: 20))
        
        //锚点最终的位置
        self.drawPoint(rect:CGRect(x: (referView.frame.minX + 111 - 10) - 3, y: (referView.frame.minY + 265 - 10) - 283, width: 20, height: 20))
    }
    
    func drawPoint(rect: CGRect) {
        //center point.
        let point = UIView(frame: rect)
        point.backgroundColor = .red
        point.layer.cornerRadius = 10
        point.clipsToBounds = true
        self.view.addSubview(point)
    }
    
    
    func doAnimation() {
        // ======== 控制速度曲线的动画。
//        let time = UICubicTimingParameters(controlPoint1: CGPoint(x: 0.0, y: 0.0), controlPoint2: CGPoint(x: 0.2, y: 1.0))
//        let animator = UIViewPropertyAnimator(duration: 0.8, timingParameters: time)
//        animator.addAnimations {
//            self.imageView.frame = CGRect(x: self.centerX(w: 361), y: 100, width: 361, height: 426)
//            self.imageView.alpha = 1.0
//        }
//        animator.startAnimation()
//        animator.addCompletion {[weak self] _ in
//            guard let self = self else { return }
//            self.scaleAnimation()
//        }
        self.scaleAnimation()
    }
    
    //3. 设置放大动画。
    func scaleAnimation() {
        weak var weakImgView = self.imageView
        let rect = self.imageView.frame
        let finalToRect = CGRect.copy(frame: rect, x: rect.minX - 3, y: rect.minY - 283)
        UIView.animate(withDuration: 3) {
            weakImgView?.layer.anchorPoint = CGPoint(x: 111.0/361.0, y: 265/426.0)
            weakImgView?.frame = finalToRect
            weakImgView?.transform = CGAffineTransformScale(CGAffineTransformMakeRotation(-Double.pi/18), 3.0, 3.0)
        } completion: { _ in
            debugPrint("============ \(String(describing: weakImgView?.frame))")
        }
    }
    
    //4. 设置回退动画
    func unScaleAnimation() {
        weak var weakImgView = self.imageView
        let center = CGPoint(x: self.imageView.center.x + 3, y: self.imageView.center.y + 283)
        UIView.animate(withDuration: 3) {
            weakImgView?.center = center
            weakImgView?.transform = CGAffineTransformIdentity
        } completion: { _ in
            debugPrint("============ \(String(describing: weakImgView?.frame))")
        }
    }
    
    
    @IBAction func doRerun(_ sender: Any) {
        if !isEnable {
            self.doAnimation()
        } else {
            self.unScaleAnimation()
        }
        self.isEnable = !self.isEnable
    }
    
    @IBAction func doReset(_ sender: Any) {
        self.setImage()
        self.isEnable = false
    }

}



public extension CGRect {
    
    static func copy(frame:CGRect,
                     x:CGFloat? = nil,
                     y:CGFloat? = nil,
                     w:CGFloat? = nil,
                     h:CGFloat? = nil) -> CGRect {
        let iX = ((x != nil) ? x : frame.minX) ?? 0.0
        let iY = ((y != nil) ? y : frame.minY) ?? 0.0
        let iW = ((w != nil) ? w : frame.size.width) ?? 0.0
        let iH = ((h != nil) ? h : frame.size.height) ?? 0.0
        let rect = CGRect(x: iX, y: iY, width: iW, height: iH)
        return rect
    }
    
    
    static func copyCenter(frame:CGRect,
                           w:CGFloat? = nil,
                           h:CGFloat? = nil) -> CGRect {
        let iW = ((w != nil) ? w : frame.size.width) ?? 0.0
        let iH = ((h != nil) ? h : frame.size.height) ?? 0.0
        let iX = frame.minX + frame.width/2.0 - iW/2.0
        let iY = frame.minY + frame.height/2.0 - iH/2.0
        let rect = CGRect(x: iX, y: iY, width: iW, height: iH)
        return rect
    }
    
    static func centerOf(frame: CGRect) -> CGPoint {
        return CGPoint(x: frame.width/2.0, y: frame.height/2.0)
    }
    
}
