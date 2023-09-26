//
//  ViewController.swift
//  YYBezierPath
//
//  Created by HarrisonFu on 2022/8/9.
//

import UIKit
public let NTScrrenW = UIScreen.main.bounds.width
public let NTScrrenH = UIScreen.main.bounds.height

enum SideType {
    case leftRight
    case leftTop
    case topRight
}

class ViewController: UIViewController {


    override func viewDidLoad() {
        super.viewDidLoad()
        
        //1. top circle.
        let circle = NTCircle(radius:(60, 80, 70))
        self.view.addSubview(circle)
        
//        //1. 中心点
//        let center = UIView(frame: CGRect(x:(NTScrrenW - 4)/2.0, y: (NTScrrenH - 4)/2.0, width: 4, height: 4))
//        center.backgroundColor = .red
//        center.layer.cornerRadius = 2.0
//        self.view.addSubview(center)
        
        
        //y=-(x2-x1/(y2-y1)* [x-(x1+x2)/2]+(y1+y2)/2
        let point0 = CGPoint(x: 150, y: 600)
        drawPoint(point: point0, color: .red)
        let point1 = CGPoint(x: 100, y: 850)
        drawPoint(point: point1, color: .green)
        let point2 = CGPoint(x: 300, y: 850)
        drawPoint(point: point2, color: .blue)
        calculateCircle(p0: point0, p1: point1, p2: point2)
    
        
    }
    
    
    func calculateCircle(p0: CGPoint, p1: CGPoint, p2:CGPoint) {
        
        //-(x2-x1/(y2-y1) * [x-(x1+x2)/2]+(y1+y2)/2
        
        //-(x2-x1/(y2-y1)
        let A = -(p1.x - p0.x)/(p1.y - p0.y)
        let D = -(p2.x - p0.x)/(p2.y - p0.y)
        
        //(x1+x2)/2
        let B = (p1.x + p0.x)/2.0
        let E = (p2.x + p0.x)/2.0
        
        //(y1+y2)/2
        let C = (p1.y + p0.y)/2.0
        let F = (p2.y + p0.y)/2.0
        
        let x = (D*E - A*B - F + C)/(D-A)
        let y = A*x - A*B + C
        let center = CGPoint(x: x, y: y)
        let R = sqrt(pow(x - p0.x, 2.0) + pow(y - p0.y, 2.0))
        
        drawPoint(point: center, color: .black)
        
        let tPath = UIBezierPath(arcCenter:center, radius: R, startAngle: 0, endAngle: 2.0 * .pi, clockwise:true)
        let shape = CAShapeLayer()
        shape.lineWidth = 3.0
        shape.path = tPath.cgPath
        shape.fillColor = UIColor.clear.cgColor
        shape.strokeColor = UIColor.red.cgColor
        self.view.layer.addSublayer(shape)
    }

    
    func drawPoint(point:CGPoint, color:UIColor = .blue) {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        view.center = CGPoint(x: point.x, y: point.y)
        view.backgroundColor = color
        self.view.addSubview(view)
    }
}

class NTCircle : UIView {
    var Circles: (L: CircleType, T: CircleType, R: CircleType)?
    var iCenter = CGPoint(x:0, y: 0)
    let sLayer = CAShapeLayer()
    let path = UIBezierPath()
    convenience init(radius:(L:CGFloat, T:CGFloat, R:CGFloat)) {
        self.init(frame: CGRect(x:0, y: 0, width: NTScrrenW, height:NTScrrenH))
        self.iCenter = self.boundsCenter()
        self.initCircles(radius: radius)
        self.initBase()
    }
    
    func initCircles(radius:(L:CGFloat, T:CGFloat, R:CGFloat)) {
        let MH: CGFloat = 5.0
        //top
        let tCenter = CGPoint(x: self.iCenter.x, y: self.iCenter.y - MH - radius.T )
        let tPath = UIBezierPath(arcCenter:tCenter, radius: radius.T, startAngle: 0, endAngle: 2.0 * .pi, clockwise:true)
        let T:CircleType = CircleType(radius:radius.T,
                            center: tCenter,
                            sAngle:0.0,
                            eAngle: 2.0 * .pi,
                            path:tPath)
        //left
        let d_LX = (MH + radius.L) * Double(sinf(.pi / 3.0))
        let d_LY = (MH + radius.L) * Double(sinf(.pi / 6.0))
        let lCenter = CGPoint(x: self.iCenter.x - d_LX , y: self.iCenter.y + d_LY)
        let lPath = UIBezierPath(arcCenter:lCenter, radius: radius.L, startAngle: 0, endAngle: 2.0 * .pi, clockwise:true)
        let L:CircleType = CircleType(radius: radius.L,
                            center: lCenter,
                            sAngle: 0.0,
                            eAngle: 2.0 * .pi,
                            path:lPath)
        
        //right
        let d_RX = (MH + radius.R) * Double(sinf(.pi / 3.0))
        let d_RY = (MH + radius.R) * Double(sinf(.pi / 6.0))
        let rCenter = CGPoint(x: self.iCenter.x + d_RX , y: self.iCenter.y + d_RY)
        let rPath = UIBezierPath(arcCenter:rCenter, radius: radius.R, startAngle: 0, endAngle: 2.0 * .pi, clockwise:true)
        let R:CircleType = CircleType(radius: radius.R,
                            center: rCenter,
                            sAngle: 0.0,
                            eAngle: 2.0 * .pi,
                            path:rPath)
        self.Circles = (L, T, R)
    }
    
    
    func initBase() {
        
        if let l = Circles?.L, let t = Circles?.T, let r = Circles?.R {
//            self.layer.addSublayer(drawShapeLayer(circle:l))
//            self.layer.addSublayer(drawShapeLayer(circle:t))
//            self.layer.addSublayer(drawShapeLayer(circle:r))
            print("=====L:\(l.radius) ===== R: \(r.radius)")
            calculateXPoints(l, t, reverse: true, sideType: .leftTop)
            calculateXPoints(l, r, reverse: r.radius < l.radius, sideType: .leftRight)
            calculateXPoints(t, r, sideType: .topRight)
            
            if let Circles = Circles {
                let path = UIBezierPath()
                path.move(to: Circles.L.startPoint)
                path.addArc(withCenter: Circles.L.center, radius: Circles.L.radius, startAngle: Circles.L.sAngle, endAngle: Circles.L.eAngle, clockwise: true)
                let dx = abs(Circles.L.endPoint.x - Circles.T.startPoint.x) / 2.0
                let dy = abs(Circles.L.endPoint.y - Circles.T.startPoint.y) / 2.0
                let controlPoint = CGPoint(x: Circles.L.endPoint.x + dx, y: Circles.L.endPoint.y - dy)
                
                path.addQuadCurve(to: Circles.T.startPoint, controlPoint: controlPoint) //Circles.L.crossing_endPoint
                
                path.addArc(withCenter: Circles.T.center, radius: Circles.T.radius, startAngle: Circles.T.sAngle, endAngle: Circles.T.eAngle, clockwise: true)
                path.addArc(withCenter: Circles.R.center, radius: Circles.R.radius, startAngle: Circles.R.sAngle, endAngle: Circles.R.eAngle, clockwise: true)
                path.close()
                let shape = CAShapeLayer()
                shape.lineWidth = 3.0
                shape.path = path.cgPath
                shape.fillColor = UIColor.clear.cgColor
                //shape.strokeColor = UIColor.red.cgColor
                
                shape.shadowRadius = 15.0
                shape.shadowOpacity = 0.90
                shape.shadowOffset = CGSize.zero
                shape.shadowColor = UIColor.red.cgColor //f1f1f1
                shape.shadowPath = path.cgPath.copy(strokingWithWidth: 12.0, lineCap: .round, lineJoin: .round, miterLimit: 0)
                self.layer.addSublayer(shape)
                
                //如果想实现只有内部阴影，则可以通过 masker来截取。
                let mask = CAShapeLayer()
                mask.path = path.cgPath
                shape.mask = mask
                
            }
            
        }
        
        
        func calculateXPoints(_ circle0: CircleType, _ circle1:CircleType, reverse:Bool = false, sideType:SideType) {
            //r0 r1.
            let yy = pow((circle1.center.y - circle0.center.y), 2.0)
            let xx = pow((circle1.center.x - circle0.center.x), 2.0)
            let AB = sqrt(yy + xx)
            
            let AO = (pow(circle0.radius, 2.0) - pow(circle1.radius, 2.0) + pow(AB, 2.0)) / (2.0 * AB)
            
            //相交圆圆心的连线 和 相交玄的交点 O
            //let Ox = circle0.center.x + AO/AB*(circle1.center.x - circle0.center.x)
            //let Oy = circle0.center.y + AO/AB*(circle1.center.y - circle0.center.y)
            
            //相交点1
            let angle1 = acos(AO/circle0.radius)
            let angle2 = asin(abs(circle0.center.y - circle1.center.y)/AB)
            let Cx = circle0.center.x + circle0.radius * cos(angle1 + angle2)
            var Cy = circle0.center.y + circle0.radius * sin(angle1 + angle2)
            if reverse {
                Cy = circle0.center.y - circle0.radius * sin(angle1 + angle2)
            }
            
            //相交点2
            let angle3 = angle1 - angle2
            let Dx = circle0.center.x + circle0.radius * cos(angle3)
            var Dy = circle0.center.y - circle0.radius * sin(angle3)
            if reverse {
                Dy = circle0.center.y + circle0.radius * sin(angle3)
            }
            
            var point = CGPoint(x: 0, y: 0)
            let dAngle = .pi / 10.0
            switch sideType {
            case .leftRight:
                point = Dy > Cy ? CGPoint(x: Dx, y: Dy) : CGPoint(x: Cx, y: Cy)
                if let Circles = Circles {
                    Circles.L.sAngle = acos((point.x - Circles.L.center.x) / Circles.L.radius) + dAngle
                    Circles.L.crossing_startPoint = point
                    Circles.L.startPoint = CGPoint(x: Circles.L.center.x + Circles.L.radius * cos(Circles.L.sAngle),
                                                   y: Circles.L.center.y + Circles.L.radius * sin(Circles.L.sAngle))
                    
                    Circles.R.eAngle = .pi - acos((Circles.R.center.x - point.x) / Circles.R.radius) - dAngle
                    Circles.R.crossing_endPoint = point
                    Circles.R.endPoint = CGPoint(x: Circles.R.center.x - Circles.R.radius * cos(.pi - Circles.R.eAngle),
                                                   y: Circles.R.center.y + Circles.R.radius * sin(.pi - Circles.R.eAngle))
                    drawPoint(point: Circles.L.startPoint, color: .red)
                    drawPoint(point: Circles.R.endPoint, color: .green)
                }
            case .leftTop:
                point = Cx < Dx ?  CGPoint(x: Cx, y: Cy) : CGPoint(x: Dx, y: Dy)
                if let Circles = Circles {
                    Circles.L.eAngle = 2.0 * .pi - acos((point.x - Circles.L.center.x) / Circles.L.radius) - dAngle
                    Circles.L.crossing_endPoint = point
                    Circles.L.endPoint = CGPoint(x: Circles.L.center.x + Circles.L.radius * cos(2.0 * .pi - Circles.L.eAngle),
                                                 y: Circles.L.center.y - Circles.L.radius * sin(2.0 * .pi - Circles.L.eAngle))
                    
                    Circles.T.sAngle = .pi - acos((Circles.T.center.x - point.x) / Circles.T.radius) + dAngle
                    Circles.T.crossing_startPoint = point
                    Circles.T.startPoint = CGPoint(x: Circles.T.center.x - Circles.T.radius * cos(.pi - Circles.T.sAngle),
                                                   y: Circles.T.center.y + Circles.T.radius * sin(.pi - Circles.T.sAngle))
                    drawPoint(point: Circles.L.endPoint, color: .blue)
                    drawPoint(point: Circles.T.startPoint, color: .orange)
                }
            case .topRight:
                point = Cx > Dx ?  CGPoint(x: Cx, y: Cy) : CGPoint(x: Dx, y: Dy)
                if let Circles = Circles {
                    Circles.T.eAngle = acos((point.x - Circles.T.center.x) / Circles.T.radius) - dAngle
                    Circles.T.crossing_endPoint = point
                    Circles.T.endPoint = CGPoint(x: Circles.T.center.x + Circles.T.radius * cos(Circles.L.eAngle),
                                                 y: Circles.T.center.y + Circles.T.radius * sin(Circles.L.eAngle))
                    
                    Circles.R.sAngle = .pi + acos((Circles.R.center.x - point.x) / Circles.R.radius) + dAngle
                    Circles.R.crossing_startPoint = point
                    Circles.R.startPoint = CGPoint(x: Circles.R.center.x - Circles.R.radius * cos(-.pi + Circles.R.sAngle),
                                                   y: Circles.R.center.y + Circles.R.radius * sin(-.pi + Circles.R.sAngle))
                }
            }
            
//            let view = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
//            view.center = CGPoint(x: point.x, y: point.y)
//            view.backgroundColor = .green
//            self.addSubview(view)
//
//            let view1 = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
//            view1.center = CGPoint(x: Dx, y: Dy)
//            view1.backgroundColor = .red
//            self.addSubview(view1)
        }
        
        
    }
    
    func addLine(circle:CircleType, length:Double) {
        let view1 = UIView(frame: CGRect(x: circle.center.x, y: circle.center.y, width: length, height: 1))
        view1.backgroundColor = .purple
        self.addSubview(view1)
    }
    
    func drawPoint(point:CGPoint, color:UIColor = .blue) {
//        let view = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
//        view.center = CGPoint(x: point.x, y: point.y)
//        view.backgroundColor = color
//        self.addSubview(view)
    }
    
    func drawShapeLayer(circle:CircleType) -> CAShapeLayer {
        let shape = CAShapeLayer()
        shape.lineWidth = 3.0
        shape.path = circle.path.cgPath
        shape.fillColor = UIColor.clear.cgColor
        shape.strokeColor = UIColor.red.cgColor
        return shape
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.sLayer.path = self.path.cgPath
    }
}


extension UIView {
    func boundsCenter() -> CGPoint {
        return CGPoint(x: self.bounds.width / 2.0, y: self.bounds.height / 2.0)
    }
    
}


class CircleType {
    var radius:CGFloat = 0
    var center:CGPoint = CGPoint.zero
    var sAngle:CGFloat = 0
    var eAngle:CGFloat = 0
    var startPoint:CGPoint  = CGPoint.zero
    var endPoint:CGPoint  = CGPoint.zero
    var path:UIBezierPath = UIBezierPath()
    var crossing_startPoint = CGPoint.zero
    var crossing_endPoint = CGPoint.zero
    init(radius:CGFloat, center: CGPoint, sAngle: CGFloat, eAngle: CGFloat, path:UIBezierPath) {
        self.radius = radius
        self.center = center
        self.sAngle = sAngle
        self.eAngle = eAngle
        self.path = path
    }
}



