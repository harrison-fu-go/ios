//
//  StateMachine.swift
//  BLETools
//
//  Created by zk-fuhuayou on 2021/8/6.
//

import Foundation

public class OtaStateMachine<State: Hashable, Transition: Hashable> {
    public typealias Operation = () -> Void
    private var body = [State: Operation?]()
    public private(set) var previousState: State?
    public private(set) var lastTransition: Transition?
    public private(set) var currentState: State? {
        willSet {
            previousState = currentState
        }
        didSet {
            if let state = currentState {
                body[state]?? ()
            }
        }
    }
    public var initialState: State? {
        didSet {
            if oldValue == nil, initialState != nil {
                currentState = initialState
            }
        }
    }
    private var stateTransitionTable: [State: [Transition: State]] = [:]
    public init() {
    }
    
    //切换到指定状态时，执行Operation
    public func add(state: State, entryOperation: Operation?) {
        body[state] = entryOperation
    }
    public func add(transition: Transition, fromState: State, toState: State) {
        var bag = stateTransitionTable[fromState] ?? [:]
        bag[transition] = toState
        stateTransitionTable[fromState] = bag
    }
    public func add(transition: Transition, fromStates: Set<State>, toState: State) {
        fromStates.forEach {
            add(transition: transition, fromState: $0, toState: toState)
        }
    }
    public func fire(transition: Transition) {
        guard let state = currentState else { return }
        guard let toState = stateTransitionTable[state]?[transition] else { return }
        lastTransition = transition
        currentState = toState
    }
}
