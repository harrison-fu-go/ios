//
//  AppVersion.swift
//  iGlasses
//
//  Created by Matthew on 2021/4/24.
//

import Foundation

struct AppVersion: Codable {
    
    let latestVersion: String
    let versionCode: Int
    let linkAppStore: URL
    let forceUpdate: Bool
    let updateDesc: String
    
    enum CodingKeys: String, CodingKey {
        case latestVersion
        case linkAppStore
        case forceUpdate
        case versionCode
        case updateDesc
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.latestVersion = try container.decode(String.self, forKey: .latestVersion)
        self.versionCode = try container.decode(Int.self, forKey: .versionCode)
        self.linkAppStore = try container.decode(URL.self, forKey: .linkAppStore)
        self.forceUpdate = try container.decode(Bool.self, forKey: .forceUpdate)
        self.updateDesc = try container.decode(String.self, forKey: .updateDesc)
    }
    
    init(latestVersion:String, versionCode:Int, linkAppStore:URL, forceUpdate:Bool, updateDesc:String) {
        self.latestVersion = latestVersion
        self.versionCode = versionCode
        self.linkAppStore = linkAppStore
        self.forceUpdate = forceUpdate
        self.updateDesc = updateDesc
    }
    
}
