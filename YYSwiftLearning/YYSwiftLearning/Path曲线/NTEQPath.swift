//
//  NTEQPath.swift
//  YYSwiftLearning
//
//  Created by HarrisonFu on 2023/3/29.
//

import UIKit
import SnapKit

class NTEQPath: UIView {
    var sW = UIScreen.main.bounds.width
    var sH = UIScreen.main.bounds.height
    var contentView: UIView = UIView();

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.drawView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func drawView() {
        var val = NTEQ.getFh(gain: 10, Fc: 1000, Fs: 48000.0, Q: 0.4)
        print("======== func_hz0: \(val)")
        
        val = NTEQ.getFh(gain: 8, Fc: 20000, Fs: 48000.0, Q: 1.4)
        print("======== func_hz0: \(val)")
        
        val = NTEQ.getFh(gain: 80, Fc: 20000, Fs: 48000.0, Q: 1.4)
        print("======== func_hz0: \(val)")
        
        let vMargin = 0.0;
        let hMargin = 24.0;
        let height = 280.0
        self.addSubview(self.contentView)
        contentView.snp.makeConstraints { make in
            make.leading.equalTo(hMargin)
            make.trailing.equalToSuperview().offset(-hMargin)
            make.height.equalTo(height)
            make.top.equalToSuperview().offset(vMargin)
        }
        contentView.backgroundColor = .black
        
        //draw center line.
        self.drawLine(startPoint: CGPoint(x: 0, y: height/2.0), endPoint: CGPoint(x: sW - hMargin * 2.0, y: height/2.0))
        
        let path = UIBezierPath()
        var points = [CGPoint]();
        for i in 0 ... 18 {
            var dY:Double = 0
            if i % 4 == 1 {
                dY = -60
            } else if i % 4 == 3{
                dY = 60
            }
            let y = height/2.0 + dY
            let point = CGPoint(x: CGFloat(i) * 20.0 + 20.0, y: y)
//            self.drawPoint(center: point)
            points.append(point)
            
            if i == 0 {
                path.move(to: point)
            } else if i % 2 == 0 {
                
                let gradentView = UIView(frame: CGRect(x: points[i-2].x, y: min(points[i-1].y, point.y), width: 40, height: 60))
                contentView.addSubview(gradentView)
                
                path.addQuadCurve(to: point, controlPoint: points[i-1])
                let gradient = CAGradientLayer()
                gradient.frame = gradentView.bounds
                gradient.colors = [UIColor.white.alpha(0.35).cgColor, UIColor.white.alpha(0.0225).cgColor]
                let locations:[NSNumber] = [0, 1]
                if points[i-1].y < point.y {
                    gradient.colors = [UIColor.white.alpha(0.0225).cgColor, UIColor.white.alpha(0.35).cgColor]
                }
                gradient.locations = locations
                gradentView.layer.addSublayer(gradient)
                
                let temP = UIBezierPath()
                let point_2 = self.contentView.convert(points[i-2], to: gradentView)
                let point_1 = self.contentView.convert(points[i-1], to: gradentView)
                let point_0 = self.contentView.convert(point, to: gradentView)
                temP.move(to: point_2)
                temP.addQuadCurve(to: point_0, controlPoint: point_1)
                temP.close()
                let masker = CAShapeLayer()
                masker.path = temP.cgPath
                gradentView.layer.mask = masker
            }
        }
        let layer = CAShapeLayer()
        layer.path = path.cgPath
        path.lineWidth = 1.0
        layer.strokeColor = UIColor.clear.cgColor
        layer.fillColor = UIColor.clear.cgColor
        contentView.layer.addSublayer(layer)
    }
    
    @discardableResult
    func drawPoint(center: CGPoint, bg:UIColor = .yellow) -> UIView {
        let size = 4.0
        let point = UIView(frame: CGRect(x: 0, y: 0, width:size, height: size));
        point.backgroundColor = bg
        point.center = center;
        self.contentView.addSubview(point)
        return point
    }
    
    func drawLine(startPoint: CGPoint, endPoint:CGPoint, color: UIColor = .green) {
        let path = UIBezierPath()
        path.move(to: startPoint)
        path.addLine(to: endPoint)
        path.lineWidth = 1.0
        let layer = CAShapeLayer()
        layer.path = path.cgPath
        layer.strokeColor = color.cgColor
        contentView.layer.addSublayer(layer)
    }
}


public extension UIColor {
    func alpha(_ alpha: CGFloat) -> UIColor {
        return withAlphaComponent(alpha)
    }
}
