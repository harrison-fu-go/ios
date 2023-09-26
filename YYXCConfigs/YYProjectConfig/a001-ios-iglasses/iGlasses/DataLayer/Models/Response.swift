//
//  Response.swift
//  iGlasses
//
//  Created by Matthew on 2021/4/14.
//

import Foundation

struct ResponseError: Codable {
    let code: Int
    let message: String
}

struct GeneralResponse<T: Codable>: Codable {
    let code: Int
    let message: String
    let data: T?
    
    enum CodingKeys: String, CodingKey {
        case code
        case message
        case data
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.code = try container.decode(Int.self, forKey: .code)
        self.message = try container.decode(String.self, forKey: .message)
        self.data = try container.decodeIfPresent(T.self, forKey: .data)
//        if T.self == NoDataReturn.self {
//            data = NoDataReturn() as? T
//        } else if container.contains(.data) {
//            data = try container.decode(T.self, forKey: .data)
//        }
    }
}

struct EmptyData: Codable {
}
