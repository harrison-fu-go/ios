//
//  YYGradientView.swift
//  YYGradientView
//
//  Created by HarrisonFu on 2022/6/22.
//

import Foundation
import UIKit


class YYGradientView: UIView {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(hex: 0xD7D8D8)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.drawPathGradient1()
    }
    
    func drawPathGradient() {
        
        UIGraphicsBeginImageContext(self.bounds.size);
        _ = UIGraphicsGetCurrentContext();
        
        let path = CGMutablePath()
        let rect = CGRect(x:0, y:0, width:300, height:300)
        path.move(to: CGPoint(x: rect.minX, y:  rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y:  rect.maxY))
        path.addLine(to: CGPoint(x: rect.width, y:  rect.maxY))
        path.addLine(to: CGPoint(x: rect.width, y:  rect.minY))
        path.closeSubpath()
        
        let context = UIGraphicsGetCurrentContext()   // 上下文
        self.drawRadialGradient(context: context!,
                              path: path,
                                startColor: UIColor.red.cgColor,
                              endColor: UIColor.yellow.cgColor)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let imgView = UIImageView(image: img)
        addSubview(imgView)
    }
    
    
    func drawGradientRect(context: CGContext, path:CGPath, startColor:CGColor, endColor:CGColor) {
        let colors = [startColor, endColor] // 渐变色数组
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        //CGFloat locations[] = { 0.0, 0.3, 1.0 }; // 颜色位置设置,要跟颜色数量相等，否则无效
        let gradient = CGGradient(colorsSpace: colorSpace, colors: colors as CFArray, locations: nil)// 渐变颜色效果设置
        
        //获取到起止点
        let pathRect = path.boundingBox
        let startPoint = CGPoint(x:pathRect.midX, y:pathRect.midY)
        let endPoint = CGPoint(x:pathRect.maxX, y:pathRect.maxY)
        context.saveGState()
        context.addPath(path); // 上下文添加路径
        context.clip();
        // 绘制线性渐变
        context.drawLinearGradient(gradient!, start: startPoint, end: endPoint, options: CGGradientDrawingOptions.drawsBeforeStartLocation)
        context.restoreGState()
        
    }
    
    
    //圆半径方向渐变
    func drawRadialGradient(context: CGContext, path:CGPath, startColor:CGColor, endColor:CGColor)
    {
        let colors = [startColor, endColor] // 渐变色数组
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let gradient = CGGradient(colorsSpace: colorSpace, colors: colors as CFArray, locations: nil)// 渐变颜色效果设置
        
        let pathRect = path.boundingBox
        let center = CGPoint(x: pathRect.midX, y: pathRect.midY)
        let radius = pathRect.size.height / 2.0
        
        let endCenter = CGPoint(x: pathRect.midX - 10, y: pathRect.midY + 20)

        context.saveGState()
        context.addPath(path); // 上下文添加路径
        context.clip(using: .evenOdd)
        context.drawRadialGradient(gradient!, startCenter: center, startRadius: 50, endCenter: endCenter, endRadius: radius, options: CGGradientDrawingOptions.drawsAfterEndLocation)
        
        context.restoreGState()
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
    
    func drawPathGradient1() {
        
//        let path = UIBezierPath(arcCenter: CGPoint(x: 200, y: 300),
//                                radius: 180, startAngle: -.pi, endAngle: 0, clockwise: true)
//        path.addArc(withCenter: CGPoint(x: 290, y: 300), radius: 90, startAngle: 0, endAngle: .pi/2.0, clockwise: true)
//        path.addLine(to: CGPoint(x: 110, y: 290))
//        path.addArc(withCenter: CGPoint(x: 110, y: 300), radius: 90, startAngle: .pi/2.0, endAngle:.pi, clockwise: true)
//        path.close()
//
//        let layer = CAShapeLayer()
//        layer.path = path.cgPath
//        layer.strokeColor = UIColor.red.cgColor
//        layer.fillColor = UIColor.clear.cgColor
//        layer.lineWidth = 0.0
//        self.layer.addSublayer(layer)
//
//        layer.masksToBounds = false
         
        let p0 = UIBezierPath(arcCenter: CGPoint(x: 200, y: 300),
                              radius: 180, startAngle: -.pi , endAngle: -.pi/2.0, clockwise: true)
        p0.lineCapStyle = .butt
        
        _ = drawGradientPath(center: CGPoint(x: 200, y: 300),
                         radius: 180,
                         path: p0.cgPath,
                         startColor:  UIColor.red.alpha(0.0).cgColor, endColor: UIColor.red.alpha(0.2).cgColor)
        
        let p1 = UIBezierPath(arcCenter: CGPoint(x: 290, y: 300), radius: 90, startAngle:0, endAngle: .pi/2.0, clockwise: true)
        p1.lineCapStyle = .square
        _ = drawGradientPath(center: CGPoint(x: 290, y: 300),
                         radius: 90,
                         path: p1.cgPath,
                         startColor: UIColor.red.alpha(0.0).cgColor, endColor: UIColor.red.alpha(0.2).cgColor,
        endCenter: CGPoint(x: 290, y: 300))

        let p2 = UIBezierPath(arcCenter: CGPoint(x: 110, y: 300), radius: 90, startAngle: .pi/2.0, endAngle:.pi, clockwise: true)
        p2.lineCapStyle = .square
        _ = drawGradientPath(center: CGPoint(x: 110, y: 300),
                         radius: 90,
                         path: p2.cgPath,
                         startColor: UIColor.red.alpha(0.0).cgColor, endColor: UIColor.red.alpha(0.2).cgColor)
    }
    
    
    func drawGradientPath(center:CGPoint, radius:CGFloat,  path:CGPath, startColor:CGColor, endColor:CGColor, endCenter:CGPoint? = nil) -> UIImageView {
        
        guard let context = UIGraphicsGetCurrentContext() else { return UIImageView()}   // 上下文
        // 渐变颜色效果设置
        let colors = [startColor, endColor] // 渐变色数组
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let locations: [CGFloat] = [0.0,1.0]
        let gradient = CGGradient(colorsSpace: colorSpace, colors: colors as CFArray, locations: locations)
        context.saveGState()
        
        var endC = center
        if let endCenter = endCenter {
            endC = endCenter
        }
                
        // 上下文添加路径
        context.addPath(path)
        context.clip(using: .evenOdd)
        context.drawRadialGradient(gradient!, startCenter: center, startRadius: radius - 55, endCenter: endC, endRadius: radius, options: CGGradientDrawingOptions.drawsAfterEndLocation)
        context.restoreGState()

        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let imgView = UIImageView(image: img)
        addSubview(imgView)
        return imgView
    }
    
}


extension UIColor {
    public convenience init(_ hex:String, alpha: CGFloat = 1.0){
        var cString: String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if cString.hasPrefix("#") {
            cString = String(cString[cString.index(cString.startIndex, offsetBy: 1)...])
        }
        if cString.count != 6 {
            cString = "000000"
        }
        var rgbValue: UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        self.init(red:CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: alpha)
    }
    
    public convenience init(hex: Int, alpha: CGFloat = 1) {
        let components = (
                R: CGFloat((hex >> 16) & 0xff) / 255,
                G: CGFloat((hex >> 08) & 0xff) / 255,
                B: CGFloat((hex >> 00) & 0xff) / 255
        )
        self.init(red: components.R, green: components.G, blue: components.B, alpha: alpha)
    }

}


public extension UIColor {
    public func alpha(_ alpha: CGFloat) -> UIColor {
        return withAlphaComponent(alpha)
    }
}
