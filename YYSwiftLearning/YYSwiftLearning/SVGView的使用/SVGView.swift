//
//  SVGView.swift
//  YYSwiftLearning
//
//  Created by HarrisonFu on 2023/12/14.
//
import Foundation
import SnapKit
import Macaw
public class NTSVGImageView : UIView {
    var svgView: SVGView
    var lightFill: UIColor? = nil
    var darkFill: UIColor? = nil
    public init(_ svg:String,
                frame: CGRect = .zero,
                lightFill: UIColor? = nil,
                darkFill: UIColor? = nil,
                background: UIColor = .clear) {
        self.svgView = SVGView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        self.svgView.fileName = svg.replacingOccurrences(of: ".svg", with: "")
        self.svgView.backgroundColor = background
        self.darkFill = darkFill
        self.lightFill = lightFill
        super.init(frame: frame)
        self.drawUI()
    }
    
    //update fill color.
    public func updateFill(color: UIColor) {
        self.updateStroke(node: self.svgView.node, fillColor: color)
    }
    
    //update node
    private func updateStroke(node: Node, fillColor: UIColor) {
        if let shape = node as? Shape {
            shape.fill = Macaw.Color(val: fillColor.svgRGB().val).with(a: fillColor.svgRGB().alpha)
        } else if let group = node as? Group {
            group.contents.forEach { node in
                updateStroke(node: node, fillColor: fillColor)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func drawUI() {
        self.addSubview(self.svgView)
        self.svgView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
    }
}


extension UIColor {
    
    func svgRGB() -> (val:Int, alpha: Double) {
        var fRed : CGFloat = 0
        var fGreen : CGFloat = 0
        var fBlue : CGFloat = 0
        var fAlpha: CGFloat = 0
        if self.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha) {
            let iRed = Int(fRed * 255.0)
            let iGreen = Int(fGreen * 255.0)
            let iBlue = Int(fBlue * 255.0)
            let rgb = (iRed << 16) + (iGreen << 8) + iBlue
            return (rgb, fAlpha)
        } else {
            return (0x000000, 1.0)
        }
    }
}
