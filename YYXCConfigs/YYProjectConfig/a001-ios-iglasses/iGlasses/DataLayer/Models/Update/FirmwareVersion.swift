//
//  FirmwareVersion.swift
//  iGlasses
//
//  Created by Matthew on 2021/4/24.
//

import Foundation

struct FirmwareVersion: Codable {
    let versionCode: Int
    let latestVersion: String
    let download: URL
    let updateDesc: String
    
    enum CodingKeys: String, CodingKey {
        case versionCode
        case latestVersion
        case download
        case updateDesc
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.versionCode = try container.decode(Int.self, forKey: .versionCode)
        self.latestVersion = try container.decode(String.self, forKey: .latestVersion)
        self.download = try container.decode(URL.self, forKey: .download)
        self.updateDesc = try container.decode(String.self, forKey: .updateDesc)
    }
}
