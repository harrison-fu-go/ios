//
//  Base64.swift
//  iGlasses
//
//  Created by zk-fuhuayou on 2021/5/17.
//

import Foundation

//swiftlint:disable force_unwrapping
struct Base64 {
    //编码
    func encoding(plainString:String) -> String {
        return plainString.base64Encoding()
    }
    
    //解码
    func decoding(encodedString:String) -> String {
        return encodedString.base64Decoding()
    }
}


extension String {
    //编码
    func base64Encoding() -> String {
        let plainData = self.data(using: String.Encoding.utf8)
        let base64String = plainData?.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        if let base64String = base64String {
            return String(base64String)
        } else {
            return ""
        }
    }
    
    //解码
    func base64Decoding() -> String {
        if self.isEmpty {
            return self
        }
        let decodedData = NSData(base64Encoded: self, options: NSData.Base64DecodingOptions(rawValue: 0))
        let decodedString = NSString(data: decodedData! as Data, encoding: String.Encoding.utf8.rawValue) ?? ""
        return decodedString as String
    }
    
}
