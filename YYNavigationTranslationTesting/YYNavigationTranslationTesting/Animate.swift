//
//  Animate.swift
//  YYNavigationTranslationTesting
//
//  Created by HarrisonFu on 2022/7/6.
//

import Foundation
import UIKit

class AnimateModel:NSObject, UIViewControllerAnimatedTransitioning, CAAnimationDelegate {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let contentView = transitionContext.containerView
        let fromVc = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        let toVc = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        let fromView = fromVc?.view
        let toView = toVc?.view
        fromView?.frame = transitionContext.initialFrame(for: fromVc!)
        toView?.frame = transitionContext.finalFrame(for: toVc!)
        contentView.addSubview(toView!)
        let time = self.transitionDuration(using: transitionContext)
//        fromView!.alpha = 1
//        toView!.alpha = 0
        
        let fromBtn = self.getBtn(superV: fromView!)
        let toBtn = self.getBtn(superV: toView!)
        fromBtn?.alpha = 0.0
        toBtn?.alpha = 1.0
        let toFrame = toBtn!.frame
        toBtn?.frame = fromBtn!.frame
        
        // 这的key是设置不同效果的动画，下面有整理
//        let animation = [CABasicAnimation animationWithKeyPath:@"position"];
        let animation = CABasicAnimation(keyPath: "position")
        animation.delegate = self
        // 平移动画
        animation.fromValue = NSValue(cgPoint: CGPoint(x: fromBtn!.frame.origin.x, y: fromBtn!.frame.origin.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: toFrame.origin.x, y: toFrame.origin.y))
        animation.duration = time
        
        // 这的key可以区分不同不同的动画，在动画完成回调时可已经判断等操作
//        toBtn.layer.addAnimation:anima forKey:@"positionAnimation"];
        toBtn?.layer.add(animation, forKey: "positionAnimation")
        animation.setValue(transitionContext, forKey: "transitionContext")
//        UIView.animate(withDuration: time) {
////            fromView!.alpha = 0
////            toView!.alpha = 1
//
////            toBtn?.alpha = 1.0
//            toBtn?.frame = toFrame
//
//
//        } completion: { finished in
//            let cancelTransition = transitionContext.transitionWasCancelled
//            transitionContext.completeTransition(!cancelTransition)
//            fromBtn?.alpha = 1.0
//        }
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {

        let transitionContext = anim.value(forKey: "transitionContext") as! UIViewControllerContextTransitioning
        let cancelTransition = transitionContext.transitionWasCancelled
        transitionContext.completeTransition(!cancelTransition)
    }
    
    
    func getBtn(superV: UIView) -> UIButton? {
        var btn:UIButton?
        _ = superV.subviews.map { view in
            if let b = view as? UIButton {
                btn = b
            }
        }
        return btn
    }
}
