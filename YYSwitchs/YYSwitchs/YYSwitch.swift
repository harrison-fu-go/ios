//
//  YYSwitch.swift
//  YYSwitchs
//
//  Created by HarrisonFu on 2024/3/28.
//

import Foundation
import UIKit
import SwiftUI
public typealias SwitchNotifyCallback<T> = (T) -> Void
@objcMembers public class YYSwitch : UIView {
    var onSwitchCallback:SwitchNotifyCallback<YYSwitch>?
    var isOn: Bool
    public static let W:CGFloat = 56.0
    public static let H:CGFloat = 28.scaleX414
    public var isNeedShake = false
    let w:CGFloat = 56.0
    let h:CGFloat = 28.scaleX414
    var sliderBar: UIView = UIView()
    var tapView: UIView = UIView()
    var tapAnimateDisplay:Bool = true
    let onBgColor = UIColor.gray
    let offBgColor = UIColor.gray.withAlphaComponent(0.5)
    let onTapColor = UIColor.white
    let offTapColor = UIColor.white.withAlphaComponent(0.5)
    public convenience init(isOn: Bool = false, isNeedShake:Bool = false, tapAnimateDisplay:Bool = true) {
        self.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0),
                  isOn: isOn,
                  isNeedShake:isNeedShake,
                  tapAnimateDisplay: tapAnimateDisplay)
    }
    
    public init(frame: CGRect, isOn: Bool = false, isNeedShake:Bool = false, tapAnimateDisplay:Bool = true) {
        self.isOn = isOn
        self.isNeedShake = isNeedShake
        self.tapAnimateDisplay = tapAnimateDisplay
        let newFrame = CGRect.copy(frame: frame, w:w, h: h)
        super.init(frame: newFrame)
        self.updateAlphas()
        self.initBase()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initSlideBar() {
        sliderBar.backgroundColor = offBgColor
        sliderBar.frame = CGRect(x:0, y: 0, width:w, height: h)
        sliderBar.cornerRadius = h/2.0
        sliderBar.isUserInteractionEnabled = false
        self.addSubview(sliderBar)
    }
    
    func initTapButton() {
        tapView = UIView()
        tapView.backgroundColor = offTapColor
        let x = isRTL ? (self.isOn ? 4.scaleX414 : w - 20.scaleX414 - 4.scaleX414) : (self.isOn ? w - 20.scaleX414 - 4.scaleX414 : 4.scaleX414)
        tapView.frame = CGRect(x: x , y: (h - 20.scaleX414) / 2.0, width: 20.scaleX414, height: 20.scaleX414)
        tapView.cornerRadius = 10.scaleX414
        tapView.isUserInteractionEnabled = false
        self.addSubview(tapView)
    }
    
    func setIsOn(isOn: Bool) {
        if isOn == self.isOn {
            return
        }
        self.isOn = isOn
        if isOn {
            UIView.animate(withDuration: 0.2) {
                self.tapView.frame = CGRect.copy(frame: self.tapView.frame, x: self.w - 20.scaleX414 - 4.scaleX414).toRTL(view: self.tapView)
                self.sliderBar.backgroundColor = self.onBgColor
                self.tapView.backgroundColor = self.onTapColor
            }
        } else {
            UIView.animate(withDuration: 0.2) {
                self.tapView.frame = CGRect.copy(frame: self.tapView.frame, x: 4.scaleX414).toRTL(view: self.tapView)
                self.sliderBar.backgroundColor = self.offBgColor
                self.tapView.backgroundColor = self.offTapColor
            }
        }
    }
    
    func set(enable: Bool, color: UIColor = .gray) {
        mask?.removeFromSuperview()
        if !enable {
            let mask = UIView(frame: bounds)
            mask.cornerRadius = 10.scaleX414
            mask.isUserInteractionEnabled = false
            mask.backgroundColor = color
            addSubview(mask)
            self.mask = mask
        }
    }
    
    func initBase() {
        self.initSlideBar()
        self.initTapButton()
        self.isUserInteractionEnabled = true
        
        let button = UIButton(type: .custom)
        button.backgroundColor = .clear
        button.frame = self.bounds
        self.addSubview(button)
        button.addTarget(self, action: #selector(onTap(_:)), for: .touchUpInside)
    }
    
    @objc func onTap(_ sender: UIButton) {
        if self.tapAnimateDisplay {
            self.setIsOn(isOn: !self.isOn)
        }
        onSwitchCallback?(self)
        if isNeedShake {
            UIImpactFeedbackGenerator.init(style: .medium).impactOccurred()
        }
    }

    func updateAlphas() {
        debugPrint("updateAlphas_updateAlphas")
        self.sliderBar.backgroundColor = self.isOn ? self.onBgColor : self.offBgColor
        self.tapView.backgroundColor = self.isOn ? self.onTapColor : self.offTapColor
    }

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.updateAlphas()
    }

}

extension UIView {
    @IBInspectable public var borderColor: UIColor? {
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
        set {
            guard let color = newValue else {
                layer.borderColor = nil
                return
            }
            layer.borderColor = color.cgColor
        }
    }
    
    /// : Border width of view; also inspectable from Storyboard.
    @IBInspectable public var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    /// Corner radius of view; also inspectable from Storyboard.
    @IBInspectable public var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = abs(CGFloat(Int(newValue * 100)) / 100)
        }
    }
    /// : Shadow color of view; also inspectable from Storyboard.
    @IBInspectable public var shadowColor: UIColor? {
        get {
            guard let color = layer.shadowColor else { return nil }
            return UIColor(cgColor: color)
        }
        set {
            layer.shadowColor = newValue?.cgColor
        }
    }
    
    /// : Shadow offset of view; also inspectable from Storyboard.
    @IBInspectable public var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    /// : Shadow opacity of view; also inspectable from Storyboard.
    @IBInspectable public var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    /// : Shadow radius of view; also inspectable from Storyboard.
    @IBInspectable public var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    func fillToSuperView(){
        translatesAutoresizingMaskIntoConstraints = false
        if let superview = superview {
            leftAnchor.constraint(equalTo: superview.leftAnchor).isActive = true
            rightAnchor.constraint(equalTo: superview.rightAnchor).isActive = true
            topAnchor.constraint(equalTo: superview.topAnchor).isActive = true
            bottomAnchor.constraint(equalTo: superview.bottomAnchor).isActive = true
        }
    }
    var screen : CGRect {
        get {
            return UIScreen.main.bounds
        }
    }
    
    // src : https://medium.com/@sdrzn/adding-gesture-recognizers-with-closures-instead-of-selectors-9fb3e09a8f0b
    fileprivate struct AssociatedObjectKeys {
        static var tapGestureRecognizer = "MediaViewerAssociatedObjectKey_mediaViewer"
    }
    
    fileprivate typealias Action = (() -> Void)?
    
    // Set our computed property type to a closure
    fileprivate var tapGestureRecognizerAction: Action? {
        set {
            if let newValue = newValue {
                // Computed properties get stored as associated objects
                objc_setAssociatedObject(self, &AssociatedObjectKeys.tapGestureRecognizer, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            }
        }
        get {
            let tapGestureRecognizerActionInstance = objc_getAssociatedObject(self, &AssociatedObjectKeys.tapGestureRecognizer) as? Action
            return tapGestureRecognizerActionInstance
        }
    }
    
    // This is the meat of the sauce, here we create the tap gesture recognizer and
    // store the closure the user passed to us in the associated object we declared above
    public func addTapGestureRecognizer(action: (() -> Void)?) {
        self.isUserInteractionEnabled = true
        self.tapGestureRecognizerAction = action
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    // Every time the user taps on the UIImageView, this function gets called,
    // which triggers the closure we stored
    @objc fileprivate func handleTapGesture(sender: UITapGestureRecognizer) {
        if let action = self.tapGestureRecognizerAction {
            action?()
        } else {
            print("no action")
        }
    }
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
    
    static func copyFrom(frame:CGRect,
                     x:CGFloat? = nil,
                     y:CGFloat? = nil,
                     w:CGFloat? = nil,
                     h:CGFloat? = nil,
                     isRTL: Bool = false) -> CGRect {
        var rect = frame
        if isRTL && NSObject.isRTL() {
            var iX:CGFloat = 0
            if let w = w {
                iX = frame.maxX - w
            } else {
                iX = ((x != nil) ? x : frame.minX) ?? 0.0
            }
            let iY = ((y != nil) ? y : frame.minY) ?? 0.0
            let iW = ((w != nil) ? w : frame.size.width) ?? 0.0
            let iH = ((h != nil) ? h : frame.size.height) ?? 0.0
            rect = CGRect(x: iX, y: iY, width: iW, height: iH)
        } else {
            let iX = ((x != nil) ? x : frame.minX) ?? 0.0
            let iY = ((y != nil) ? y : frame.minY) ?? 0.0
            let iW = ((w != nil) ? w : frame.size.width) ?? 0.0
            let iH = ((h != nil) ? h : frame.size.height) ?? 0.0
            rect = CGRect(x: iX, y: iY, width: iW, height: iH)
        }
        return rect
    }
    
}

public extension CGRect {
    
    func toRTL(view: UIView) -> CGRect {
        guard let superV = view.superview, NSObject.isRTL() else { return self }
        return self.toRTL(superWidth: superV.frame.width)
    }
    
    func toRTL(superWidth: Double)  -> CGRect {
        let newRect = CGRect(x: superWidth - self.minX - self.width, y: self.minY, width: self.width, height: self.height)
        return newRect
    }
}


public extension NSObject {
    var isRTL:Bool {
        return UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft
    }
    
    static func isRTL() -> Bool {
        return UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft
    }
}

public class RTL: NSObject {
    public static func setBaseRTL() {
        UIView.appearance().semanticContentAttribute = self.isRTL() ? .forceRightToLeft : .forceLeftToRight
    }
}

public let DYScrrenW = UIScreen.main.bounds.width
public let DYScrrenH = UIScreen.main.bounds.height
public let designWidth = 375.0
public let designHeight = 812.0
public let DYScaleX = DYScrrenW/designWidth
public let DYScaleY = DYScrrenH/designHeight
public extension Double {
    func scaleX() -> Double {
        return self * DYScaleX
    }
    
    func scaleY() -> Double {
        return self * DYScaleY
    }
    
    func scaleW414() -> Double {
        return self * (DYScrrenW/414.0)
    }
    
    func scaleH920() -> Double {
        return self * (DYScrrenH/920.0)
    }
    
    var scaleX414: Double {
        self * (DYScrrenW/414.0)
    }
    
    var scaleY920: Double {
        self * (DYScrrenH/920.0)
    }
    
    var scaleMin: Double {
        return min(self.scaleX414, self.scaleY920)
    }
    
    var scaleMax: Double {
        return max(self.scaleX414, self.scaleY920)
    }
}
