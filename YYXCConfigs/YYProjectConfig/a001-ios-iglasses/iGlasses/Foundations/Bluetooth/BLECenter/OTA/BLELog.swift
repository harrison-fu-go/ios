//
//  BLELog.swift
//  BLETools
//
//  Created by 钟城广 on 2020/12/16.
//

import Foundation

struct BLELog :Identifiable {
    
    let id = UUID()
    
    let desc: String
    let time = Date()
    var data: Data?
    var error: String?
    
    func getHms() -> String {
        let  formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter.string(from: time)
    }
}
