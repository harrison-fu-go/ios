//
//  constants.swift
//  YYSwiftLearning
//
//  Created by HarrisonFu on 2023/6/26.
//

import UIKit
import Foundation

public let NTScrrenW = UIScreen.main.bounds.width
public let NTScrrenH = UIScreen.main.bounds.height
public let designWidth = 375.0
public let designHeight = 812.0
public let NTScaleX = NTScrrenW/designWidth
public let NTScaleY = NTScrrenH/designHeight

public let NTDesignWidth = 414.0
public let NTDesignHeight = 920.0
public let NTHorizontalMargin = 24.scaleX414
public extension Double {
    func scaleX() -> Double {
        return self * NTScaleX
    }
    
    func scaleY() -> Double {
        return self * NTScaleY
    }
    
    func scaleW414() -> Double {
        return self * (NTScrrenW/414.0)
    }
    
    func scaleH920() -> Double {
        return self * (NTScrrenH/920.0)
    }
    
    var scaleX414: Double {
        self * (NTScrrenW/414.0)
    }
    
    var scaleY920: Double {
        self * (NTScrrenH/920.0)
    }
    
    var scaleMin: Double {
        return min(self.scaleX414, self.scaleY920)
    }
    
    var scaleMax: Double {
        return max(self.scaleX414, self.scaleY920)
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

