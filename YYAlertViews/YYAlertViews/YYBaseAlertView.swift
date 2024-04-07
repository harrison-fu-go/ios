//
//  YYBaseAlertView.swift
//  YYAlertViews
//
//

import UIKit
import Foundation
import SnapKit
var avMaginH = 12.0
let avContentWidth = UIScreen.main.bounds.size.width - 2.0 * avMaginH
@objcMembers public class YYBaseAlertView: UIView {
    
    let bgView = UIView()
    let contentView = UIView()
    let titleLabel = UILabel()
    let contentLabel = UILabel()
    let cancelBtn = UIButton(type: .custom)
    let okayBtn = UIButton(type: .custom)
    let cMargin = 12.0
    let lineView = UIView()
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initBaseUI(title:String?,
                    content:String?,
                    cancel:String?,
                    ok:String?) {
        self.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
        bgView.backgroundColor = .black.withAlphaComponent(0.3)
        let contentW = avContentWidth - 2.0 * cMargin
        bgView.addTapGestureRecognizer {[weak self] in
            self?.onHide()
        }
        
        //set contentView.
        var cH = 0.0
        self.addSubview(self.contentView)
        
        //add title.
        var relyView: UIView? = nil
        if let title = title {
            var titleH = 40.0;
            let titleFont = UIFont.systemFont(ofSize: 17, weight: .bold)
            let titleSize = title.sizeOf(lineHeight: 40,
                                         font: titleFont,
                                         maxSize: CGSize(width: contentW , height: 1000))
            if titleSize.height > titleH {
                titleH = titleSize.height
            }
            self.contentView.addSubview(self.titleLabel)
            self.titleLabel.snp.makeConstraints { make in
                make.leading.equalToSuperview().offset(cMargin)
                make.trailing.equalToSuperview().offset(-cMargin)
                make.top.equalToSuperview()
                make.height.equalTo(titleH)
            }
            cH = cH + titleH;
            self.titleLabel.numberOfLines = 0
            self.titleLabel.font = titleFont;
            self.titleLabel.textColor = UIColor.black
            relyView = self.titleLabel
            self.titleLabel.text = title
        }
        
        //add conent
        if let content = content {
            var conentH = 36.0;
            let contentFont = UIFont.systemFont(ofSize: 15)
            let contentSize = content.sizeOf(lineHeight: 20,
                                             font: contentFont,
                                             maxSize: CGSize(width: contentW , height: 1000))
            if contentSize.height > conentH {
                conentH = contentSize.height
            }
            self.contentView.addSubview(self.contentLabel)
            self.contentLabel.snp.makeConstraints { make in
                make.leading.equalToSuperview().offset(cMargin)
                make.trailing.equalToSuperview().offset(-cMargin)
                if let relyView = relyView {
                    make.top.equalTo(relyView.snp.bottom)
                } else {
                    make.top.equalToSuperview()
                }
                make.height.equalTo(conentH)
            }
            cH = cH + conentH;
            self.contentLabel.numberOfLines = 0
            self.contentLabel.font = contentFont;
            self.contentLabel.textColor = UIColor.black
            relyView = self.contentLabel
            self.contentLabel.text = content
        }
        //line
        guard var relyView = relyView else { return }
        self.contentView.addSubview(self.lineView)
        self.lineView.backgroundColor = UIColor.gray
        self.lineView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(cMargin)
            make.right.equalToSuperview().offset(-cMargin)
            make.height.equalTo(1)
            make.top.equalTo(relyView.snp.bottom).offset(12)
        }
        relyView = self.lineView
        cH = cH + 1 + 12;
        
        //cancel or okay should set to 60 Height
        let okbaseH = 60.0
        cH = cH + okbaseH
        let btnH = 40.0
        let btnTopOffset = (okbaseH - btnH) / 2.0
        self.contentView.addSubview(self.cancelBtn)
        self.cancelBtn.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(btnH)
            make.right.equalTo(self.contentView.snp.centerX).offset(-40)
            make.top.equalTo(relyView.snp.bottom).offset(btnTopOffset)
        }
        self.cancelBtn.backgroundColor = .gray
        self.cancelBtn.setTitle(cancel, for: .normal)
        self.cancelBtn.setTitleColor(UIColor.black, for: .normal)
        self.cancelBtn.backgroundColor = UIColor(hex: 0x1871ff).withAlphaComponent(0.7)
        self.cancelBtn.addTapGestureRecognizer {[weak self] in
            self?.onHide()
        }
        
        self.contentView.addSubview(self.okayBtn)
        self.okayBtn.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.height.equalTo(btnH)
            make.left.equalTo(self.contentView.snp.centerX).offset(40)
            make.top.equalTo(relyView.snp.bottom).offset(btnTopOffset)
        }
        self.okayBtn.backgroundColor = UIColor(hex: 0x1871ff)
        self.okayBtn.setTitle(ok, for: .normal)
        self.okayBtn.setTitleColor(UIColor.black, for: .normal)
        self.okayBtn.addTapGestureRecognizer {[weak self] in
            self?.onConfirm()
        }
        
        self.contentView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(avMaginH)
            make.right.equalToSuperview().offset(-avMaginH)
            make.height.equalTo(cH)
            make.centerY.equalToSuperview()
        }
        self.contentView.backgroundColor = .white
        self.contentView.layer.cornerRadius = 8.0
        self.contentView.clipsToBounds = true
    }
    
    static func alert(title:String,
                      content:String,
                      cancel:String,
                      ok:String) -> YYBaseAlertView {
        let alert = YYBaseAlertView();
        alert.initBaseUI(title: title, content: content, cancel: cancel, ok: ok)
        return alert;
    }
    
    @discardableResult
    static func show(title:String,
                      content:String,
                      cancel:String,
                      ok:String) -> YYBaseAlertView{
        let alert = YYBaseAlertView();
        alert.initBaseUI(title: title, content: content, cancel: cancel, ok: ok)
        if let windowDelegate = UIApplication.shared.delegate, let iWin = windowDelegate.window {
            alert.frame = iWin?.bounds ?? .zero
            iWin?.addSubview(alert)
        }
        return alert;
    }
    
    func onHide() {
        UIView.animate(withDuration: 0.2) {[weak self] in
            guard let self = self else { return }
            self.alpha = 0
        } completion: { _ in
            self.removeFromSuperview()
        }
    }
    
    func onConfirm() {
        self.onHide()
    }
}

public extension String {
    
    func sizeOf(lineHeight:Float,
                font:UIFont,
                maxSize:CGSize,
                lineBreak:NSLineBreakMode = .byWordWrapping,
                kern: CGFloat? = nil) -> CGSize {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.maximumLineHeight = CGFloat(lineHeight)
        paragraphStyle.minimumLineHeight = CGFloat(lineHeight)
        paragraphStyle.lineSpacing = 0
        paragraphStyle.lineBreakMode = lineBreak
        var attDic:[NSAttributedString.Key : Any] = [NSAttributedString.Key.font:font, NSAttributedString.Key.paragraphStyle:paragraphStyle]
        if let kern = kern {
            attDic[NSAttributedString.Key.kern] = kern
        }
        let ns = NSString(string: self)
        let result = ns.boundingRect(with: maxSize,
                               options:NSStringDrawingOptions(rawValue:(NSStringDrawingOptions.usesLineFragmentOrigin.rawValue | NSStringDrawingOptions.usesFontLeading.rawValue)),
                               attributes: attDic, context: nil).size
        return CGSize(width: result.width + 1, height: result.height + 1)
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
