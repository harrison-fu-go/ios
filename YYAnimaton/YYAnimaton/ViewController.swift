//
//  ViewController.swift
//  YYAnimaton
//
//  Created by HarrisonFu on 2022/9/14.
//

import UIKit
class ViewController: UIViewController, CAAnimationDelegate {
    let imageView = UIImageView()
    let animation = CABasicAnimation(keyPath: "position")
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        imageView.backgroundColor = .red
        imageView.frame = CGRect(x: 100, y: 100, width: 50, height: 50)
        self.view.addSubview(imageView)
//
//
//        animation.fromValue = NSValue(cgPoint: imageView.center)
//        animation.toValue = NSValue(cgPoint: CGPoint(x: imageView.center.x, y: 325))
//        animation.duration = 0.8
//        animation.isRemovedOnCompletion = false
//        animation.fillMode = .forwards
////        animation.timingFunction = CAMediaTimingFunction(controlPoints: 0.0, 0.0, 0.2, 1.0)
//        animation.timingFunction = AnimationTimingFunction.cubicBezier(controlPoint1: 0.0, controlPoint2: 0.2)
//        imageView.layer.add(animation, forKey: nil)
//        animation.delegate = self
//
        let view0 = UIView(frame: CGRect(x: 124, y: 124, width: 2, height: 2))
        self.view.addSubview(view0)
        view0.backgroundColor = .blue

        let view1 = UIView(frame: CGRect(x: 124, y: 324, width: 2, height: 2))
        self.view.addSubview(view1)
        view1.backgroundColor = .blue
        
        self.imageView.alpha = 0.2
        
        let time = UICubicTimingParameters(controlPoint1: CGPoint(x: 0.0, y: 0.0), controlPoint2: CGPoint(x: 0.2, y: 1.0))
        let animator = UIViewPropertyAnimator(duration: 0.8, timingParameters: time)
        animator.addAnimations {
            self.imageView.frame = CGRect(x: 100, y: 300, width: 50, height: 50)
            self.imageView.alpha = 1.0
        }
        animator.startAnimation()
    }
    
    func animationDidStart(_ anim: CAAnimation) {
        debugPrint("== animationDidStart")
    }

    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        debugPrint("== animationDidStop")
        let toFrame = CGRect(x: 100, y: 300, width: 50, height: 50)
        imageView.frame = toFrame
    }
    

}

