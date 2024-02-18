//
//  LabelExtensions.swift
//  YYTextEvents
//
//  Created by HarrisonFu on 2024/1/23.
//
import SnapKit
import Foundation
public typealias NTStringInfo = (txt:String, font: UIFont?, color: UIColor?)
public typealias NTStringInfoMutable = (txts:[String], font: UIFont?, color: UIColor?)

public extension UILabel {
    
    convenience init (text:String?,
                      underLines:[String]? = nil) {
        
        let lineHeight = 20.0
        let font = UIFont.systemFont(ofSize: 14)
        let size = (text ?? "").sizeOf(lineHeight: Float(lineHeight),
                                       font: font,
                                       maxSize: CGSize(width: 300, height: 1000),
                                       lineBreak: .byWordWrapping)
        let frame = CGRect(x: 100, y:100, width: size.width, height: size.height)
        self.init(frame: frame)
        self.isUserInteractionEnabled = true
        self.numberOfLines = 0
        
        
        let str = (text ?? " ").attStr(lineHeight: Float(lineHeight),
                                       font: font,
                                       color: .red,
                                       textAlign: .center,
                                       underLines: underLines)
        self.attributedText = str
        if let underLines = underLines {
            for line in underLines {
                let range = str.string.range(of: line)
                self.addTarget(self, selector: #selector(onTapRange), range: range, identifier: line)
            }
        }
        self.backgroundColor = .green
    }
    
    @objc func onTapRange(onTapTxt:String) {
//        if let self = self as? NTTapLabel {
//            self.onTapCallback?(onTapTxt)
//        }
    }
}

class NTTapLabel: UIView, UITextViewDelegate {
    var txt:String = " "
    let txtView = UITextView()
    var linkRangeMap = [NSRange: String]()
    init (txt:String?,
          underLines:[String]? = nil) {
        let lineHeight = 20.0
        let font = UIFont.systemFont(ofSize: 14)
        if let txt = txt {
            self.txt = txt
        }
        let size = self.txt.sizeOf(lineHeight: Float(lineHeight),
                                   font: font,
                                   maxSize: CGSize(width: 300, height: 1000),
                                   lineBreak: .byWordWrapping)
        let frame = CGRect(x: 100, y:100, width: size.width, height: size.height)
        super.init(frame: frame)
        self.txtView.delegate = self
        self.txtView.isEditable = false
        self.drawUI(LH: lineHeight, font: font, UL: underLines)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func drawUI(LH: Double, font: UIFont, UL:[String]? = nil) {
        txtView.attributedText = self.txt.attStr(lineHeight: Float(LH),
                                                 font: font,
                                                 color: .red,
                                                 textAlign: .center,
                                                 underLines: UL)
        let attTxt = NSMutableAttributedString(string: self.txt)
        if let underLines = UL {
            for line in underLines {
                let range = self.txt.range(of: line)
                linkRangeMap[range] = line
                attTxt.addAttribute(.link, value: "link://", range: range)
            }
        }
        txtView.attributedText = attTxt
        self.addSubview(txtView)
        txtView.snp.makeConstraints { make in
            make.left.top.right.bottom.equalToSuperview()
        }
    }
    
    var onTapCallback: ((String) -> Void)?
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return false
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        
        var key:NSRange? = nil
        for tem in linkRangeMap.keys {
            if tem.location == characterRange.location, tem.length == characterRange.length {
                key = tem
            }
        }
        if let key = key, let linkVal = self.linkRangeMap[key] {
            print("用户点击了链接：\(String(describing: linkVal))")
            return false
        }
        print("用户点击了链接: null ")
        return false
    }
    
    
}

extension String {
    
    public func sizeOf(lineHeight:Float,
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
        return ns.boundingRect(with: maxSize,
                               options:NSStringDrawingOptions(rawValue:(NSStringDrawingOptions.usesLineFragmentOrigin.rawValue | NSStringDrawingOptions.usesFontLeading.rawValue)),
                               attributes: attDic, context: nil).size
    }
    
    func range(of string: String) -> NSRange {
        return NSString(string: self).range(of: string)
    }
    
    public func attStr(lineHeight:Float,
                       font:UIFont?,
                       color:UIColor?,
                       textAlign:NSTextAlignment,
                       lineBreak:NSLineBreakMode = .byWordWrapping,
                       kern:CGFloat? = nil,
                       underLine: Bool = false,
                       highlightInfo: NTStringInfoMutable? = nil,
                       underLines:[String]? = nil) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.maximumLineHeight = CGFloat(lineHeight)
        paragraphStyle.minimumLineHeight = CGFloat(lineHeight)
        paragraphStyle.lineSpacing = 0
        paragraphStyle.lineBreakMode = lineBreak
        var align = textAlign
        paragraphStyle.alignment = align
        let attributes = NSMutableDictionary()
        attributes.setObject(paragraphStyle, forKey: NSAttributedString.Key.paragraphStyle as NSCopying)
        let baselineOffset = (CGFloat(lineHeight) - (font ?? UIFont.systemFont(ofSize: UIFont.systemFontSize)).lineHeight) / 4
        attributes.setObject(baselineOffset, forKey: NSAttributedString.Key.baselineOffset as NSCopying)
        if let color = color {
            attributes.setObject(color, forKey:  NSAttributedString.Key.foregroundColor as NSCopying)
        }
        if let font = font {
            attributes.setObject(font, forKey: NSAttributedString.Key.font as NSCopying)
        }
        if let kern = kern {
            attributes.setObject(kern, forKey: NSAttributedString.Key.kern as NSCopying)
        }
        if underLine {
            attributes.setObject(1 , forKey: NSAttributedString.Key.underlineStyle as NSCopying)
        }
        attributes.setObject(0, forKey: NSAttributedString.Key.ligature as NSCopying)
        let str =  NSMutableAttributedString(string: self, attributes: attributes as! [NSAttributedString.Key : Any])
        
        //highlight.
        if let highlightInfo = highlightInfo {
            for hTxt in highlightInfo.txts {
//                let hTxt = highlightInfo.txt
                if let hF = highlightInfo.font {
                    str.addAttributes([NSAttributedString.Key.font : hF], range: str.string.range(of: hTxt))
                }
                if let color = highlightInfo.color {
                    str.addAttributes([NSAttributedString.Key.foregroundColor : color], range: str.string.range(of: hTxt))
                }
            }
        }
        if let underLines = underLines {
            for line in underLines {
                let range = str.string.range(of: line)
                str.addAttributes([NSAttributedString.Key.underlineStyle : 1], range: range)
                str.addAttributes([NSAttributedString.Key.backgroundColor : UIColor.blue], range: range)
            }
        }
        return str
    }
}


extension String {
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
}
