//
//  YYGradientView1.swift
//  YYGradientView
//
//  Created by HarrisonFu on 2022/8/2.
//

import UIKit

class YYGradientView1: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        drawViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
    }
    
    
    func drawViews() {
            
        let path = UIBezierPath(arcCenter: CGPoint(x: 200, y: 300),
                                radius: 180, startAngle: -.pi, endAngle: 0, clockwise: true)
        path.addArc(withCenter: CGPoint(x: 290, y: 300), radius: 90, startAngle: 0, endAngle: .pi/2.0, clockwise: true)
        path.addLine(to: CGPoint(x: 110, y: 390))
        path.addArc(withCenter: CGPoint(x: 110, y: 300), radius: 90, startAngle: .pi/2.0, endAngle:.pi, clockwise: true)
        path.close()

        let layer = CAShapeLayer()
        layer.path = path.cgPath
        layer.strokeColor = UIColor.yellow.cgColor
        layer.fillColor = UIColor.clear.cgColor //UIColor(hex: 0xD9D9D9).cgColor
        layer.lineWidth = 0.0
        self.layer.addSublayer(layer)
        
        layer.shadowColor = UIColor.red.cgColor
        layer.shadowPath = path.cgPath
        layer.shadowOpacity = 1.0
        layer.shadowRadius = 0
//        layer.shadowOffset = CGSize(width: 0, height: 0)
    
        let path1 = UIBezierPath()
        path1.move(to: CGPoint(x: 200, y:500))
        path1.addLine(to: CGPoint(x: 300, y:700))
        path1.addLine(to: CGPoint(x: 200, y:700))
        path1.close()
        let layer1 = CAShapeLayer()
        layer1.path = path1.cgPath
        layer1.strokeColor = UIColor.yellow.cgColor
        layer1.fillColor = UIColor.clear.cgColor
        layer1.lineWidth = 1.0
        self.layer.addSublayer(layer1)
        layer1.shadowPath = path1.cgPath
        layer1.shadowColor = UIColor.green.cgColor
        layer1.shadowOpacity = 0.1
        layer1.shadowRadius = 0.0
        layer1.shadowOffset = CGSize(width: 0, height: 0)

    }

}



class YYInnerShadow: CAShapeLayer {
    var innerShadowColor: CGColor? = UIColor.black.cgColor {
        didSet { setNeedsDisplay() }
    }
    
    var innerShadowOffset: CGSize = CGSize(width: 0, height: 0) {
        didSet { setNeedsDisplay() }
    }
    
    var innerShadowRadius: CGFloat = 8 {
        didSet { setNeedsDisplay() }
    }
    
    var innerShadowOpacity: Float = 1 {
        didSet { setNeedsDisplay() }
    }
    
    override init() {
        super.init()
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    func initialize() {
        self.masksToBounds      = true
        self.shouldRasterize    = true
        self.contentsScale      = UIScreen.main.scale
        self.rasterizationScale = UIScreen.main.scale
        
        setNeedsDisplay()
    }
    
    override func draw(in ctx: CGContext) {
        // 设置 Context 属性
        // 允许抗锯齿
        ctx.setAllowsAntialiasing(true);
        // 允许平滑
        ctx.setShouldAntialias(true);
        // 设置插值质量
        ctx.interpolationQuality = .high
        
        // 以下为核心代码
        
        // 创建 color space
        let colorspace = CGColorSpaceCreateDeviceRGB();
        
        var rect   = self.bounds
        var radius = self.cornerRadius
        
        // 去除边框的大小
        if self.borderWidth != 0 {
            rect   = rect.insetBy(dx: self.borderWidth, dy: self.borderWidth);
            radius -= self.borderWidth
            radius = max(radius, 0)
        }
        
        // 创建 inner shadow 的镂空路径
        let someInnerPath: CGPath = UIBezierPath(roundedRect: rect, cornerRadius: radius).cgPath
        ctx.addPath(someInnerPath)
        ctx.clip()
        
        // 创建阴影填充区域，并镂空中心
        let shadowPath = CGMutablePath()
        let shadowRect = rect.insetBy(dx: -rect.size.width, dy: -rect.size.width)
//        CGPathAddRect(shadowPath, CGAffineTransform(), shadowRect)
//        CGPathAddRect(shadowPath, nil, shadowRect)
//        CGPathAddPath(shadowPath, nil, someInnerPath);
        shadowPath.addRect(shadowRect)
        shadowPath.addPath(someInnerPath)
        shadowPath.closeSubpath()
        
        // 获取填充颜色信息
        let oldComponents = innerShadowColor?.components
        guard let oldComponents = oldComponents else { return }
        var newComponents:[CGFloat] = [0, 0, 0, 0]
        guard let innerShadowColor = innerShadowColor else { return }
        let numberOfComponents: Int = innerShadowColor.numberOfComponents;
        switch (numberOfComponents){
        case 2:
            // 灰度
            newComponents[0] = oldComponents[0]
            newComponents[1] = oldComponents[0]
            newComponents[2] = oldComponents[0]
            newComponents[3] = oldComponents[1] * CGFloat(innerShadowOpacity)
        case 4:
            // RGBA
            newComponents[0] = oldComponents[0]
            newComponents[1] = oldComponents[1]
            newComponents[2] = oldComponents[2]
            newComponents[3] = oldComponents[3] * CGFloat(innerShadowOpacity)
        default: break
        }
        
        // 根据颜色信息创建填充色
        let innerShadowColorWithMultipliedAlpha = CGColor(colorSpace: colorspace, components: newComponents)
        guard let innerShadowColorWithMultipliedAlpha = innerShadowColorWithMultipliedAlpha else { return  }
        // 填充阴影
        ctx.setFillColor(innerShadowColorWithMultipliedAlpha)
        ctx.setShadow(offset: innerShadowOffset, blur: innerShadowRadius, color: innerShadowColorWithMultipliedAlpha)
        ctx.addPath(shadowPath)
        ctx.fillPath()
    }
}
