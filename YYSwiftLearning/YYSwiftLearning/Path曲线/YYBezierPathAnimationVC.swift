//
//  YYBezierPathAnimationVC.swift
//  YYSwiftLearning
//
//  Created by HarrisonFu on 2023/7/18.
//

import UIKit

class YYBezierPathAnimationVC: UIViewController {
    
    let bezierPathLayer = CAShapeLayer()
    let bezierPath = UIBezierPath()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "Bezier Path"
        
        
        
//        bezierPath.move(to: CGPoint(x: 100, y: 200))
//        bezierPath.addLine(to: CGPoint(x: 200, y: 300))
        
        bezierPath.move(to: CGPoint(x: 120, y: 180))
        bezierPath.addCurve(to: CGPoint(x: 230, y: 400),
                                   controlPoint1: CGPoint(x: 150, y: 200),
                                   controlPoint2: CGPoint(x: 180, y: 300))
        bezierPath.addLine(to: CGPoint(x: 250, y: 450))
        bezierPathLayer.lineWidth = 1.0
        bezierPathLayer.strokeColor = UIColor.red.cgColor
        bezierPathLayer.fillColor = UIColor.clear.cgColor
        bezierPathLayer.path = bezierPath.cgPath
        self.view.layer.addSublayer(bezierPathLayer)
        

        let bezierPathAnimate = UIBezierPath()
        bezierPathAnimate.move(to: CGPoint(x: 120, y: 180))
        bezierPathAnimate.addCurve(to: CGPoint(x: 230, y: 400),
                                   controlPoint1: CGPoint(x: 150, y: 200),
                                   controlPoint2: CGPoint(x: 180, y: 300))
        bezierPathAnimate.addLine(to: CGPoint(x: 250, y: 450))
        
        
//        let keyFA = CAKeyframeAnimation(keyPath: "path")
////        let pint1 = NSValue(cgPoint: CGPoint(x: 100, y: 0))
////        let pint2 = NSValue(cgPoint: CGPoint(x: 200, y: 20))
////        keyFA.values = [bezierPathLayer.position, pint2];
////        keyFA.keyTimes = [0.0, 0.5, 0.9, 2]
////        keyFA.duration = 5.0
//        keyFA.path = bezierPathAnimate.cgPath
//        keyFA.repeatCount = 10
//        keyFA.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut) //速度曲线
//        keyFA.fillMode = .forwards
//        keyFA.calculationMode = .paced
//        keyFA.rotationMode = .rotateAuto ////旋转的模式,auto就是沿着切线方向动，autoReverse就是转180度沿着切线动
//        keyFA.isRemovedOnCompletion = false ////结束后是否移除动画
//        self.bezierPathLayer.add(keyFA, forKey: "")
        
        let path = UIBezierPath()
        var point = CGPoint(x: 10, y: 260)
        path.move(to: point)
        point = CGPoint(x: 60, y: 300)
        path.addLine(to: point)
        point = CGPoint(x: 140, y: 160)
        path.addLine(to: point)
        path.close()
        let checkmarkLayer = CAShapeLayer()
        checkmarkLayer.path = path.cgPath
        checkmarkLayer.lineWidth = 5
        checkmarkLayer.strokeColor = UIColor.red.cgColor
        checkmarkLayer.fillColor = UIColor.clear.cgColor
        view.layer.addSublayer(checkmarkLayer)
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            
            CATransaction.begin()
            CATransaction.setCompletionBlock {
                checkmarkLayer.fillColor = UIColor.blue.cgColor
                let animation = CABasicAnimation(keyPath: "path")
                animation.toValue = UIBezierPath(rect: CGRect(x: 200, y: 200, width: 200, height: 200)).cgPath
                animation.duration = 5
                animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
                checkmarkLayer.add(animation, forKey: nil)
                
            }
            CATransaction.commit()
        }
        
    }
    
    
}
/*
//关键帧动画
-(void)layerKeyFrameAnimation
{
    //画一个path
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(-40, 100)];
    [path addLineToPoint:CGPointMake(360, 100)];
    [path addLineToPoint:CGPointMake(360, 200)];
    [path addLineToPoint:CGPointMake(-40, 200)];
    [path addLineToPoint:CGPointMake(-40, 300)];
    [path addLineToPoint:CGPointMake(360, 300)];
      
    //几个固定点
    NSValue *orginalValue = [NSValue valueWithCGPoint:self.redView.layer.position];
    NSValue *value_1 = [NSValue valueWithCGPoint:CGPointMake(300, 300)];
    NSValue *value_2 = [NSValue valueWithCGPoint:CGPointMake(400, 300)];
    NSValue *value_3 = [NSValue valueWithCGPoint:CGPointMake(400, 400)];
      
    //变动的属性,keyPath后面跟的属性是CALayer的属性
    CAKeyframeAnimation *keyFA = [CAKeyframeAnimation animationWithKeyPath:@"position"];
      
    //value数组，放所有位置信息，如果设置path，此项会被忽略
    keyFA.values = @[orginalValue,value_1,value_2,value_3];
    //动画路径
//    keyFA.path = path.CGPath;
    //该属性是一个数组，用以指定每个子路径(AB,BC,CD)的时间。如果你没有显式地对keyTimes进行设置，则系统会默认每条子路径的时间为：ti=duration/(帧数)，即每条子路径的duration相等
    keyFA.keyTimes = @[@(0.0),@(0.5),@(0.9),@(2)];
    //动画总时间
    keyFA.duration = 5.0f;
    //重复次数，小于0无限重复
    keyFA.repeatCount = 10;
      
    /*
    这个属性用以指定时间函数，类似于运动的加速度
    kCAMediaTimingFunctionLinear//线性
    kCAMediaTimingFunctionEaseIn//淡入
    kCAMediaTimingFunctionEaseOut//淡出
    kCAMediaTimingFunctionEaseInEaseOut//淡入淡出
    kCAMediaTimingFunctionDefault//默认
     */
    keyFA.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
      
   /*
    fillMode的作用就是决定当前对象过了非active时间段的行为. 比如动画开始之前,动画结束之后。如果是一个动画CAAnimation,则需要将其removedOnCompletion设置为NO,要不然fillMode不起作用.
     
    下面来讲各个fillMode的意义
    kCAFillModeRemoved 这个是默认值,也就是说当动画开始前和动画结束后,动画对layer都没有影响,动画结束后,layer会恢复到之前的状态
    kCAFillModeForwards 当动画结束后,layer会一直保持着动画最后的状态
    kCAFillModeBackwards 这个和kCAFillModeForwards是相对的,就是在动画开始前,你只要将动画加入了一个layer,layer便立即进入动画的初始状态并等待动画开始.你可以这样设定测试代码,将一个动画加入一个layer的时候延迟5秒执行.然后就会发现在动画没有开始的时候,只要动画被加入了layer,layer便处于动画初始状态
    kCAFillModeBoth 理解了上面两个,这个就很好理解了,这个其实就是上面两个的合成.动画加入后开始之前,layer便处于动画初始状态,动画结束后layer保持动画最后的状态.
        //添加动画
    */
    keyFA.fillMode = kCAFillModeForwards;
      
    /*
     在关键帧动画中还有一个非常重要的参数,那便是calculationMode,计算模式.该属性决定了物体在每个子路径下是跳着走还是匀速走，跟timeFunctions属性有点类似
     其主要针对的是每一帧的内容为一个座标点的情况,也就是对anchorPoint 和 position 进行的动画.当在平面座标系中有多个离散的点的时候,可以是离散的,也可以直线相连后进行插值计算,也可以使用圆滑的曲线将他们相连后进行插值计算. calculationMode目前提供如下几种模式
 
     kCAAnimationLinear calculationMode的默认值,表示当关键帧为座标点的时候,关键帧之间直接直线相连进行插值计算;
     kCAAnimationDiscrete 离散的,就是不进行插值计算,所有关键帧直接逐个进行显示;
     kCAAnimationPaced 使得动画均匀进行,而不是按keyTimes设置的或者按关键帧平分时间,此时keyTimes和timingFunctions无效;
     kCAAnimationCubic 对关键帧为座标点的关键帧进行圆滑曲线相连后插值计算,对于曲线的形状还可以通过tensionValues,continuityValues,biasValues来进行调整自定义,这里的数学原理是Kochanek–Bartels spline,这里的主要目的是使得运行的轨迹变得圆滑;
     kCAAnimationCubicPaced 看这个名字就知道和kCAAnimationCubic有一定联系,其实就是在kCAAnimationCubic的基础上使得动画运行变得均匀,就是系统时间内运动的距离相同,此时keyTimes以及timingFunctions也是无效的.
     */
    keyFA.calculationMode = kCAAnimationPaced;
      
    //旋转的模式,auto就是沿着切线方向动，autoReverse就是转180度沿着切线动
    keyFA.rotationMode = kCAAnimationRotateAuto;
  
    //结束后是否移除动画
    keyFrameAnimation.removedOnCompletion = NO;
  
     //添加动画
    [self.redView.layer addAnimation:keyFA forKey:@""];
}
*/
