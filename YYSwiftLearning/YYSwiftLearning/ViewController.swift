//
//  ViewController.swift
//  YYSwiftLearning
//
//  Created by zk-fuhuayou on 2021/8/25.
//

import UIKit
class ViewController: UIViewController {
    
    @IBOutlet var longpressBtn: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        let data = Data([0x42,0x45,0x53,0x43,0x41,0x50])
        let bytes = data.toArray(type: UInt8.self)
        let str = String(bytes: Array(bytes), encoding: .ascii) ?? ""
        print("===== \(str)")
        
//        let imgView = UIImageView(frame: CGRect(x: 100, y: 200, width: 200, height: 300))
//        var img = UIImage(named: "app1")?.drawRadius(rect: imgView.bounds, corner: 20, backgroundColor: .clear)
//        imgView.image = img
//        self.view.addSubview(imgView)
//        
//
//        let dataBytes = Array([0x28, 0x00, 0x00, 0x00].reversed())
//        let dData = Data(bytes: dataBytes, count: dataBytes.count)
//        let dData = Data([0,0,12,67]).reversed().reversed()
        
//        let dData = Data([0x28, 0x00, 0x00, 0x00])
        let dData = Data([0xD8, 0xFF, 0xFF, 0xFF]) //FFFF FF
        let vals = Data(dData).toArray(type: Int32.self)
        print("===== \(vals)")
    }
    

    //MARK: 指针的研究和学习
    @IBAction func onPointerTesting(_ sender: AnyObject) {
        SwiftPointer().structPointerTesting()
    }
    
    //MARK: GCD多线程的实现
    @IBAction func gcdThread(_ sender: AnyObject) {
        let gcd = GCD()
        gcd.testing()
    }
    
    @IBAction func metal(_ sender: AnyObject) {
        let vc = YYMetalVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func charts(_ sender: AnyObject) {
        let vc = YYChartVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func collectViewCard(_ sender: AnyObject) {
        let vc = CollectionCardVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func bezierPathAnimation(_ sender: AnyObject) {
        let vc = YYBezierPathAnimationVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func gotoCSV(_ sender: AnyObject) {
        let vc = YYCSVVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func gotoSandboxPath(_ sender: AnyObject) {
        let vc = YYFilePathVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func setupLongpress() {
        guard let longpressBtn = longpressBtn else { return }
        longpressBtn.addTarget(self, action: #selector(onLongPress(_:)), for: .touchUpInside)
    }
    
    @objc func onLongPress(_ sender: UIButton) {
        let menu = UIMenuController.shared
        if !menu.isMenuVisible {
            menu.showMenu(from: sender, rect: sender.bounds)
        }
    }

}

class UICopyLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    func sharedInit() {
        isUserInteractionEnabled = true
        addGestureRecognizer(UILongPressGestureRecognizer(target: self,
                                                          action: #selector(showMenu(_:))))
    }
    
    @objc func showMenu(_ sender: UILongPressGestureRecognizer) {
        becomeFirstResponder()
        let menu = UIMenuController.shared
        if !menu.isMenuVisible {
            menu.showMenu(from: self, rect: self.bounds)
        }
        
    }
    
    override func copy(_ sender: Any?) {
        let board = UIPasteboard.general
        board.string = text
        let menu = UIMenuController.shared
        menu.hideMenu()
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(UIResponderStandardEditActions.copy(_:)) {
            return true
        }
        return false
    }
    
}




extension UIImage {
    
    public func drawRadius(rect: CGRect,
              corner: CGFloat,
              backgroundColor: UIColor,
              padding: CGFloat = 0.0) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale)
        let path = UIBezierPath(roundedRect: rect,
                                cornerRadius: corner)
        let context = UIGraphicsGetCurrentContext()
        context?.saveGState()
        context?.setFillColor(backgroundColor.cgColor)
        path.addClip()
        context?.addPath(path.cgPath)
        context?.fillPath()
        self.draw(in: CGRectInset(rect, padding, padding))
        context?.restoreGState()
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}


extension Data {
    func toArray<T>(type: T.Type) -> [T] {
        //    return self.withUnsafeBytes {
        //      [T](UnsafeBufferPointer(start: $0, count: self.count/MemoryLayout<T>.stride))
        //    }
        
        let array = self.withUnsafeBytes { (pointer: UnsafeRawBufferPointer) -> [T] in
            if let ptrAddress = pointer.baseAddress, pointer.count > 0 {
                let pointer = ptrAddress.assumingMemoryBound(to: type) // here you got UnsafePointer<UInt8>
                let buffer = UnsafeBufferPointer(start: pointer,count: self.count/MemoryLayout<T>.stride)
                return Array<T>(buffer)
            }
            return Array<T>()
        }
        return array
    }
}
