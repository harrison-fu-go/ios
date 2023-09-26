//
//  LoginStateMachine.swift
//  iGlasses
//
//  Created by Matthew on 2021/4/16.
//

import Foundation
import RxSwift

public enum LoginState: Int, StateMachineDataSource, Equatable {
  case unlogin = 1
  case logedin
  case expired

  func shouldTransitionFrom(_ from: LoginState, to: LoginState) -> Bool {
    switch (from, to) {
    case (.unlogin, .logedin):
        return true
    case (.unlogin, .expired):
        return true
    case (.logedin, .unlogin):
        return true
    case (.logedin, .expired):
        return true
    case (.expired, .unlogin):
        return true
    case (.expired, .logedin):
        return true
    default:
        return false
    }
  }
}

class LoginStateMachineDelegate: StateMachineDelegate {
  let subject = PublishSubject<(from:LoginState, to:LoginState)>()

  typealias StateType = LoginState

  func didTransitionFrom(_ from: LoginState, to: LoginState) {
    subject.onNext((from: from, to: to))
  }
}

final class LoginStateMachine {
  static let `default` = StateMachine<LoginStateMachineDelegate>(
    initialState: .unlogin,
    delegate: LoginStateMachineDelegate())
}
