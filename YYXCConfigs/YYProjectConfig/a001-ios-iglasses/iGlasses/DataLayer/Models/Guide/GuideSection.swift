//
//  GuideSection.swift
//  iGlasses
//
//  Created by xian punan on 2021/5/28.
//

import Foundation

struct GuideSection: Codable {
    let link: URL
    let sectionImage: URL
    let title: String
    let items: [GuideItem]?
    
    enum CodingKeys: String, CodingKey {
        case link
        case sectionImage
        case title
        case items
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.link = try container.decode(URL.self, forKey: .link)
        self.sectionImage = try container.decode(URL.self, forKey: .sectionImage)
        self.title = try container.decode(String.self, forKey: .title)
        self.items = try? container.decodeIfPresent([GuideItem].self, forKey: .items)
    }
}
