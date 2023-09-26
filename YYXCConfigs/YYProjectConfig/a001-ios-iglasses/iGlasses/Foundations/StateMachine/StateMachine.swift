//
//  StateMachine.swift
//  iGlasses
//
//  Created by Matthew on 2021/4/16.
//

import Foundation

protocol StateMachineDataSource {
  func shouldTransitionFrom(_ from: Self, to: Self) -> Bool
}

protocol StateMachineDelegate: class {
  associatedtype StateType: StateMachineDataSource
  func didTransitionFrom(_ from: StateType, to: StateType)
}

class StateMachine<P: StateMachineDelegate> {
  private var _state: P.StateType {
    didSet {
      delegate.didTransitionFrom(oldValue, to: _state)
    }
  }

  var state: P.StateType {
    get {
      return _state
    }
    set {
      if _state.shouldTransitionFrom(_state, to: newValue) {
        _state = newValue
      }
    }
  }

  var delegate: P

  init(initialState: P.StateType, delegate: P) {
    /// The initial state isn't technically a "transition".
    /// So we set `_state` directly.
    self._state = initialState
    self.delegate = delegate
  }
}
