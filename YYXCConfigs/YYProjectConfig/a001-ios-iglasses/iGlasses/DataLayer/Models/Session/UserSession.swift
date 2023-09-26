//
//  UserSession.swift
//  iGlasses
//
//  Created by Matthew on 2021/4/16.
//

import Foundation

public class UserSession: Codable {
  public let profile: UserProfile
  public let remoteUserSession: RemoteUserSession

  public init(profile: UserProfile, remoteUserSession: RemoteUserSession) {
    self.profile = profile
    self.remoteUserSession = remoteUserSession
  }
}
