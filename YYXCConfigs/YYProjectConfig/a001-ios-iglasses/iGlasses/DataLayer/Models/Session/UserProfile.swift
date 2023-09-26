//
//  UserProfile.swift
//  iGlasses
//
//  Created by Matthew on 2021/4/16.
//

import Foundation

public struct UserProfile: Equatable {
  public let type: Int
  public let name: String
  public let email: String
  public let mobile: String?
  public let avatar: URL
  public let expired: Bool
  public let deadline: Date

  private enum CodingKeys: CodingKey {
    case type
    case name
    case email
    case mobile
    case avatar
    case expired
    case deadline
  }

  public init(type: Int,
    name: String, email: String,
    mobile: String?, avatar: URL,
    expired: Bool, deadline: Date) {
    self.type = type
    self.name = name
    self.email = email
    self.mobile = mobile
    self.avatar = avatar
    self.expired = expired
    self.deadline = deadline
  }
}

extension UserProfile: Codable {
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(type, forKey: .type)
    try container.encode(name, forKey: .name)
    try container.encode(email, forKey: .email)
    try container.encodeIfPresent(mobile, forKey: .mobile)
    try container.encode(avatar, forKey: .avatar)
    try container.encode(expired, forKey: .expired)

    let datetime = DateFormatter.mysql.string(from: deadline)
    try container.encode(datetime, forKey: .deadline)
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.type = try container.decode(Int.self, forKey: .type)
    self.name = try container.decode(String.self, forKey: .name)
    self.email = try container.decode(String.self, forKey: .email)
    self.mobile = try container.decodeIfPresent(String.self, forKey: .mobile)
    self.avatar = try container.decode(URL.self, forKey: .avatar)
    self.expired = try container.decode(Bool.self, forKey: .expired)

    let datetime = try container.decode(String.self, forKey: .deadline)
    guard let date = DateFormatter.mysql.date(from: datetime) else {
      throw DataError.dataCorrupt(description: "Invalid datetime format: \(datetime)")
    }

    deadline = date
  }
}
