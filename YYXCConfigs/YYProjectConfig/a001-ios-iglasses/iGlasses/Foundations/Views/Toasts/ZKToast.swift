//
//  ZKToast.swift
//  iGlasses
//
//  Created by zk-fuhuayou on 2021/5/31.
//

import UIKit

class ZKToast {
    let width:CGFloat = 268
    
    var title: NSMutableAttributedString?
    let titleFont = UIFont.systemFont(ofSize: 18.0, weight: .medium)
    var content:NSMutableAttributedString = NSMutableAttributedString(string: " ")
    let contentFont = UIFont.systemFont(ofSize: 14.0, weight: .regular)
    
    let bWidth:CGFloat = 268.0
    var bHeight:CGFloat = 82.0
    var contentLineCount:Int = 1
    var contentHeight:CGFloat = 20
    let kSW = UIScreen.main.bounds.width
    let kSH = UIScreen.main.bounds.height
    var lineHeight:CGFloat = 35
    var verticalMargin:CGFloat = 8.0
    var horizontalMargin:CGFloat = 16.0
    init(content: String, title:String? = nil) {
        self.content = NSMutableAttributedString(string: content)
        let range = NSRange(content)
        if let range = range {
            self.content.addAttributes([NSAttributedString.Key.font : self.contentFont], range: range)
            self.content.addAttributes([NSAttributedString.Key.strokeColor : UIColor.white], range: range)
        }
        
        if let iTitle = title {
            self.title = NSMutableAttributedString(string: iTitle)
            let range = NSRange(location: 0, length: iTitle.count)
            self.title?.addAttributes([NSAttributedString.Key.font : self.titleFont], range: range)
            self.title?.addAttributes([NSAttributedString.Key.strokeColor : UIColor.white], range: range)
        }
    }
    
    static func toast(_ content:String, title:String? = nil, duration: Int = 4) {
        DispatchQueue.main.async {
            ZKToast(content: content, title: title).toast(duration: duration)
        }
    }
    
    private func toast(duration: Int) {
        calculateHeight()
        let baseView = UIView(frame: CGRect(x: (kSW - bWidth) / 2.0, y: (kSH - 100.0) - bHeight - verticalMargin, width: bWidth, height: bHeight))
        baseView.backgroundColor = UIColor(hex: 0x1e1e1e, alpha: 0.75)
        baseView.layer.cornerRadius = 8.0
        baseView.clipsToBounds = true
        baseView.isUserInteractionEnabled = false
        if title != nil {
            let titleLabel = UILabel(frame:CGRect(x: CGFloat(0), y: CGFloat(verticalMargin), width: bWidth, height: CGFloat(25.0)))
            baseView.addSubview(titleLabel)
            titleLabel.attributedText = self.title
            titleLabel.textAlignment = .center
            titleLabel.textColor = .white
        }
        let mTop = self.verticalMargin + ((title != nil) ? (25.0 + 4) : 0.0)
        let messageLabel = UILabel(frame:CGRect(x: CGFloat(horizontalMargin), y: CGFloat(mTop), width: bWidth - horizontalMargin * 2.0, height: CGFloat(lineHeight * CGFloat(self.contentLineCount))))
        baseView.addSubview(messageLabel)
        messageLabel.attributedText = self.content
        messageLabel.textAlignment = .center
        messageLabel.textColor = .white
        messageLabel.numberOfLines = 0
        let window = UIApplication.shared.windows.first
        if let window = window {
            window.addSubview(baseView)
        }
        
        UIView.animate(withDuration: Double(duration)) {
            baseView.alpha = 0.2
        } completion: { _ in
            baseView.removeFromSuperview()
        }
    }
    
    func calculateHeight() {
        let size = content.size()
        contentLineCount = Int((size.width / (bWidth - horizontalMargin * 2.0)) + 0.999)
        if self.title != nil {
            contentHeight = (lineHeight * CGFloat(contentLineCount))
            bHeight = verticalMargin * 2.0 + 25 + 4 + contentHeight
        } else if self.title == nil {
            if contentLineCount == 1 {
                verticalMargin = 8.0
                lineHeight = 25
            }
            contentHeight = (lineHeight * CGFloat(contentLineCount))
            bHeight = verticalMargin * 2.0 + contentHeight
        }
    }
}
