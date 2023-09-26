//
//  OtaStateHelper.swift
//  BLETools
//
//  Created by zk-fuhuayou on 2021/8/6.
//

import Foundation

class OtaStateHelper {
    enum State: Int {
        case IDLE
        case PREPARE
        case START_OTA
        case NEXT_BLOCK
        case TRANSFER_SEGMENT
        case CHECK_ACK
        case FINISH
        case FAILED
    }
    
    enum Transition: Int {
        case Confiing
        case START//click start button
        case RECEIVED//read indicate
        case WRITE_SUCCESS //数据发送成功（write）
        case SENT //数据发送完毕 （withoutResponse and data is Empty）
        case RESEND
        case DONE //firmware全部
        case ERROR
    }
    
    lazy var otaStateMachine: OtaStateMachine<State, Transition> = {
        let otaStateMachine = OtaStateMachine<State, Transition>()
        otaStateMachine.add(transition: .Confiing, fromState: .IDLE, toState: .PREPARE)
        otaStateMachine.add(transition: .START, fromState: .PREPARE, toState: .START_OTA)
        otaStateMachine.add(transition: .RECEIVED, fromState: .START_OTA, toState: .NEXT_BLOCK)
        otaStateMachine.add(transition: .WRITE_SUCCESS, fromState: .NEXT_BLOCK, toState: .TRANSFER_SEGMENT)
        otaStateMachine.add(transition: .SENT, fromState: .TRANSFER_SEGMENT, toState: .CHECK_ACK)
        otaStateMachine.add(transition: .RESEND, fromState: .CHECK_ACK, toState: .TRANSFER_SEGMENT)
        otaStateMachine.add(transition: .RECEIVED, fromState: .CHECK_ACK, toState: .NEXT_BLOCK)
        
        otaStateMachine.add(transition: .DONE, fromState: .NEXT_BLOCK, toState: .FINISH)
        otaStateMachine.add(transition: .ERROR, fromStates: [.IDLE, .PREPARE, .START_OTA, .NEXT_BLOCK, .TRANSFER_SEGMENT, .CHECK_ACK], toState: .FAILED)
        return otaStateMachine
    }()
}
