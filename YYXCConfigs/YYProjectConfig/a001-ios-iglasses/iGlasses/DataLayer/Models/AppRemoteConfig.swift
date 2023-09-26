//
//  AppRemoteConfig.swift
//  iGlasses
//
//  Created by xian punan on 2021/5/21.
//

import Foundation

struct AppRemoteConfig: Codable {
    let isAppStoreReviewing: Bool
    
    enum CodingKeys: String, CodingKey {
        case isAppStoreReviewing
    }
    
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.isAppStoreReviewing = try container.decode(Bool.self, forKey: .isAppStoreReviewing)
//    }
}
