//
//  FontIcon.swift
//  YYSVGIcon
//
//  Created by HarrisonFu on 2022/7/20.
//

import Foundation
import UIKit
import Foundation

public enum IconfontNames: String {
    case setting = "\u{e602}"
    case arrowForward = "\u{e601}"
}

public extension UIFont {
    class func iconfont(ofSize: CGFloat) -> UIFont? {
        return UIFont.init(name: "iconfont", size: ofSize)
    }
}

public class NTIcon
{
    static func icon(name: IconfontNames, color: UIColor, size: CGFloat = 200) -> UIImageView {
        let drawText = name.rawValue
        UIGraphicsBeginImageContextWithOptions(CGSize(width: size, height: size), false, UIScreen.main.scale)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.center
        drawText.draw(in: CGRect(x:0, y:0, width:size, height:size),
                      withAttributes: [.font: UIFont.iconfont(ofSize: size) ?? UIFont(), .paragraphStyle: paragraphStyle, .foregroundColor: color])
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return UIImageView(image: image)
    }
    
    static func label(name: IconfontNames, color: UIColor, size: CGFloat = 44) -> UILabel {
        let label = UILabel()
        label.font = UIFont.iconfont(ofSize: size)
        label.text = name.rawValue
        label.textColor = color
        return label
    }
    
    static func button(name: IconfontNames, color: UIColor, size: CGFloat = 44) -> UIButton {
        let button = UIButton(type: .custom)
        button.titleLabel?.font = UIFont.iconfont(ofSize: size)
        button.setTitle(name.rawValue, for: .normal)
        button.setTitle(name.rawValue, for: .highlighted)
        button.setTitleColor(color, for: .normal)
        button.setTitleColor(color, for: .highlighted)
        return button
    }
}
