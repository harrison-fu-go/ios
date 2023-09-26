//
//  DataExtension.swift
//  BLETools
//
//  Created by 钟城广 on 2020/12/14.
//

import Foundation
//swiftlint:disable force_try force_unwrapping empty_count legacy_constructor unused_closure_parameter opening_brace joined_default_parameter
extension String {

    /// Create `Data` from hexadecimal string representation
    ///
    /// This takes a hexadecimal representation and creates a `Data` object. Note, if the string has any spaces or non-hex characters (e.g. starts with '<' and with a '>'), those are ignored and only hex characters are processed.
    ///
    /// - returns: Data represented by this hexadecimal string.

    func hexadecimal() -> Data? {
        var data = Data(capacity: count / 2)

        let regex = try! NSRegularExpression(pattern: "[0-9a-f]{1,2}", options: .caseInsensitive)
        regex.enumerateMatches(in: self, range: NSMakeRange(0, utf16.count)) { match, flags, stop in
            let byteString = (self as NSString).substring(with: match!.range)
            var num = UInt8(byteString, radix: 16)!
            data.append(&num, count: 1)
        }

        guard data.count > 0 else { return nil }

        return data
    }

}

extension Data {

    /// Create hexadecimal string representation of `Data` object.
    ///
    /// - returns: `String` representation of this `Data` object.

    func hexadecimal() -> String {
        return map { String(format: "%02x", $0) }
            .joined(separator: "")
    }
}


protocol UIntToBytesConvertable {
    func toBytes(endian:Bool) -> [UInt8]
}

extension UIntToBytesConvertable {
    func toByteArr<T>(endian: T, count: Int) -> [UInt8] {
        var _endian = endian
        let bytePtr = withUnsafePointer(to: &_endian) {
            $0.withMemoryRebound(to: UInt8.self, capacity: count) {
                UnsafeBufferPointer(start: $0, count: count)
            }
        }
        return [UInt8](bytePtr)
    }
}

extension UInt16: UIntToBytesConvertable {
    func toBytes(endian:Bool = false) -> [UInt8] {
        let temp = endian ? self.bigEndian : self.littleEndian
        return toByteArr(endian: temp, count: MemoryLayout<UInt16>.size)
    }
}

extension UInt32: UIntToBytesConvertable {
    func toBytes(endian:Bool = false) -> [UInt8] {
        let temp = endian ? self.bigEndian : self.littleEndian
        return toByteArr(endian: temp, count: MemoryLayout<UInt32>.size)
    }
}

extension UInt64: UIntToBytesConvertable {
    func toBytes(endian:Bool = false) -> [UInt8] {
        let temp = endian ? self.bigEndian : self.littleEndian
        return toByteArr(endian: temp, count: MemoryLayout<UInt64>.size)
    }
}

extension Int {
    func toUInt8() -> UInt8{
        return UInt8(self)
    }
}

extension StringProtocol {
    var hexaData: Data { .init(hexa) }
    var hexaBytes: [UInt8] { .init(hexa) }
    private var hexa: UnfoldSequence<UInt8, Index> {
        sequence(state: startIndex) { startIndex in
            guard startIndex < self.endIndex else { return nil }
            let endIndex = self.index(startIndex, offsetBy: 2, limitedBy: self.endIndex) ?? self.endIndex
            defer { startIndex = endIndex }
            return UInt8(self[startIndex..<endIndex], radix: 16)
        }
    }
}
