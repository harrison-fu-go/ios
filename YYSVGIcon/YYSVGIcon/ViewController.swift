//
//  ViewController.swift
//  YYSVGIcon
//
//  Created by HarrisonFu on 2022/7/20.
//

import UIKit
import SwiftSVG
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //MARK: ----- SwiftSVG: svg font icon. use svg file.
//        let fistBump = UIView(SVGNamed: "settings")     // In the main bundle
//        fistBump.frame = CGRect(x: 200, y: 200, width: 20, height: 20)
//        self.view.addSubview(fistBump)
        
        
//        let svgURL = Bundle.main.url(forResource: "settings", withExtension: "svg")!
//        let _ = CALayer(SVGURL: svgURL) { (svgLayer) in
//            // Set the fill color
//            svgLayer.fillColor = UIColor(red:1.0, green:0.0, blue:0.0, alpha:1.00).cgColor
//            // Aspect fit the layer to self.view
//            svgLayer.resizeToFit(self.view.bounds)
//            // Add the layer to self.view's sublayers
//            self.view.layer.addSublayer(svgLayer)
//        }
        
        //MARK: ----- SwiftSVG: svg font icon. use svg path string.
//        let string = NSLocalizedString("settings", tableName: "svgIcon",
//                                       bundle: Bundle.main,
//                                       value: "",
//                                       comment: "")
//        let sockPuppetSVG = CAShapeLayer(pathString: string)
//        sockPuppetSVG.fillColor = UIColor.purple.cgColor
//        sockPuppetSVG.frame = CGRect(x: 200, y: 200, width: 50, height: 50)
//        self.view.layer.addSublayer(sockPuppetSVG)
//
        
        //MARK: ----- Symbol image: ios 13 upper.
//        let imageView = UIImageView()
//        let symbolImage = UIImage(named: "settings")
//        // 默认配置下，这个symbol image是template的，意味着他不会含有颜色，颜色由UIView级别tintColor决定
////        imageView.image = symbolImage
//        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 38, weight:.ultraLight, scale: .small)
//        let boldSymbolImage = symbolImage?.applyingSymbolConfiguration(symbolConfiguration)
//        imageView.image = boldSymbolImage
//
//        imageView.frame = CGRect(x: 200, y: 200, width: 50, height: 50)
//        self.view.addSubview(imageView)
        // 如果确定要获取系统Symbol Image
//        let systemSymbolImage = UIImage(systemName: "wifi.exclamationmark")
        // 如果要指定颜色
//        let redSymbolImage = symbolImage?.withTintColor(.red, renderingMode: .alwaysOriginal)
//        imageView.image = redSymbolImage
        
        
        //MARK: ------- use icon font.
        let label = NTIcon.label(name: .setting, color: .green)
        label.frame = CGRect(x: 100, y: 100, width: 50, height: 50)
        self.view.addSubview(label)

        let imageview = NTIcon.icon(name: .setting, color: .black)
        imageview.frame = CGRect(x: 200, y: 200, width: 50, height: 50)
        self.view.addSubview(imageview)
        
        let btton = NTIcon.button(name: .setting, color: .red)
        btton.frame = CGRect(x: 200, y: 300, width: 50, height: 50)
        self.view.addSubview(btton)
    }

    
    

}

