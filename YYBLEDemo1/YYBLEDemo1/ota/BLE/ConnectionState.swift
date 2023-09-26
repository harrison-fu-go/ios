//
//  ConnectionState.swift
//  BLETools
//
//  Created by 钟城广 on 2020/11/24.
//

import Foundation


enum ConnectionState : String{
    case idle = "Idle"
    case connecting = "Connecting"
    case connected = "Connected"
    case failed = "Failed"
    case disconnected = "Disconnected"
}
