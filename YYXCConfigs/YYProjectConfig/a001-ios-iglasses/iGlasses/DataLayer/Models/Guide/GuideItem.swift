//
//  GuideItem.swift
//  iGlasses
//
//  Created by xian punan on 2021/5/28.
//

import Foundation

struct GuideItem: Codable {
    let image: URL
    let link: URL
    let summary: String
    let title: String
    
    enum CodingKeys: String, CodingKey {
        case image
        case link
        case title
        case summary
    }
}
