//
//  StringResearchVC.swift
//  YYSwiftLearning
//
//  Created by HarrisonFu on 2024/2/18.
//

import UIKit

class StringResearchVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
//        var empty: String  = ""
//        print("empty:  \(empty)")
//        print(withUnsafePointer(to: &empty, { $0 }))
        
        print("add zero 6:  \("341".addZeroAtStart(count: 6))")
        print("add zero 6:  \("341".addZeroAtEnd(count: 6))")
        
        let bKey:[UInt8] = [0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17, 0x18, 0x19, 0x1A, 0x1B, 0x1C, 0x1D, 0x1E, 0x20, 0x21, 0x22, 0x23, 0x24, 0x25, 0x26, 0x27, 0x28, 0x29, 0x2A, 0x2B, 0x2C, 0x2D, 0x2E, 0x31, 0x32]
        let bKeyStr = NSString(bytes: bKey, length: 32, encoding: NSUTF8StringEncoding) ?? ""
        //let bKeyStr = String(bytes: bKey, encoding: .utf8) ?? ""
        print("==== bKey: \(bKeyStr)")
        
        let ivKey:[UInt8] = [0x50, 0x51, 0x52, 0x53, 0x54, 0x55, 0x56, 0x57, 0x58, 0x59, 0x5A, 0x5B, 0x5C, 0x5D, 0x5E, 0x66]
        let ivKeyStr = NSString(bytes: ivKey, length:16, encoding: NSUTF8StringEncoding) ?? ""
        print("==== ivKey: \(ivKeyStr)")
        
       // print("==== bKey: \(String.hexStr(Data(bytes: bKey, count: 32)))")
    }
    
}


extension String {
    
    //字符串不够数位，在前面补0
    func addZeroAtStart(count: Int) -> String {
        if let val = Int(self) {
            return String(format: "%0\(count)d", val)
        }
        return self
    }
    
    //字符串不够数位，在后面补0
    func addZeroAtEnd(count: Int) -> String {
        return self.padding(toLength: count, withPad: "0", startingAt: 0)
    }
    
    static func hexStr(_ data: Data) -> String {
        let hexString = data.map { String(format: "%02x", $0) }.joined()
        return hexString
    }
    
}
