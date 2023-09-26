//
//  ViewController.swift
//  YYRTL
//
//  Created by HarrisonFu on 2022/9/21.
//

import UIKit

class ViewController: UIViewController {
    let titleLabel = UILabel(frame: CGRect(x: 50, y: 100, width: 200, height: 30))
    override func viewDidLoad() {
        super.viewDidLoad()
//        UIView.appearance().semanticContentAttribute = .forceRightToLeft
        self.view.semanticContentAttribute = .forceLeftToRight
        
//        let superView = self.view.superview
//        self.view.removeFromSuperview()
//        superView?.addSubview(view)
//
//        debugPrint("=========== \(self.isRTL)")
       
        self.view.addSubview(titleLabel)
        
        titleLabel.text = "Main.welcome".localized
        titleLabel.rtlTextAlignment(.left)
        
        titleLabel.backgroundColor = .red
        titleLabel.semanticContentAttribute = .forceRightToLeft
        self.view.addSubview(titleLabel)
        
//        debugPrint("======== \( "30".toArabic())")
        
        
    }
}


public extension String {
    
    
    var localized: String {
        let unfoundStr = "XXXXXX=XXXXXX=&&&&&&"
        var str = NSLocalizedString(self, value: unfoundStr, comment: self)
        if str == unfoundStr || str == "" {
            str = NSLocalizedString(self, tableName: "en.lproj/Localizable", bundle: Bundle.main, value: self, comment: "")
        }
        return str
    }

    func paramLocalized(args: CVarArg...) -> String {
        return String(format: self.localized, args)
    }
    
    
    func toArabic(_ locale: Locale = Locale(identifier: "ar")) -> String {
        let setStr = self.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let digits = Set(setStr)
        guard !digits.isEmpty else { return self }
        //formatter.
        let formatter = NumberFormatter()
        formatter.locale = locale
        let maps: [(original: String, converted: String)] = digits.map {
            let original = String($0)
            let digit = formatter.number(from: original)!
            let localized = formatter.string(from: digit)!
            return (original, localized)
        }
        //replace.
        return maps.reduce(self) { converted, map in
            converted.replacingOccurrences(of: map.original, with: map.converted)
        }
    }
}

public extension NSObject {
    var isRTL:Bool {
        return UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft
    }
}

public extension UILabel {
    func rtlTextAlignment(_ align:  NSTextAlignment) {
        if self.isRTL {
            switch self.textAlignment {
            case .left:
                self.textAlignment = .right
            case .right:
                self.textAlignment = .left
            default:
                self.textAlignment = textAlignment
            }
        } else {
            self.textAlignment = textAlignment
        }
    }
}

public extension UIView {
    
    //1. Update to rtl
    func rtlOriginXUpdate() {

    }

    
    //1. 使用Frame控制的 view
    
    //2.
    
}

public extension CGRect {
    
    static func copy(frame:CGRect,
                     x:CGFloat? = nil,
                     y:CGFloat? = nil,
                     w:CGFloat? = nil,
                     h:CGFloat? = nil) -> CGRect {
        let iX = ((x != nil) ? x : frame.minX) ?? 0.0
        let iY = ((y != nil) ? y : frame.minY) ?? 0.0
        let iW = ((w != nil) ? w : frame.size.width) ?? 0.0
        let iH = ((h != nil) ? h : frame.size.height) ?? 0.0
        let rect = CGRect(x: iX, y: iY, width: iW, height: iH)
        return rect
    }
    
    static func copyCenter(frame:CGRect,
                           w:CGFloat? = nil,
                           h:CGFloat? = nil) -> CGRect {
        let iW = ((w != nil) ? w : frame.size.width) ?? 0.0
        let iH = ((h != nil) ? h : frame.size.height) ?? 0.0
        let iX = frame.minX + frame.width/2.0 - iW/2.0
        let iY = frame.minY + frame.height/2.0 - iH/2.0
        let rect = CGRect(x: iX, y: iY, width: iW, height: iH)
        return rect
    }
    
    static func centerOf(frame: CGRect) -> CGPoint {
        return CGPoint(x: frame.width/2.0, y: frame.height/2.0)
    }
    
}
