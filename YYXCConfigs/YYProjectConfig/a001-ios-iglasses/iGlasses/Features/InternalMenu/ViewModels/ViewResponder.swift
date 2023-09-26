//
//  DesignDemoResponder.swift
//  iGlasses
//
//  Created by Matthew on 2021/4/13.
//

import Foundation

enum InternalViewResponder {
    case designDemo
    case none
}

protocol DesignDemoResponder {
    func designDemo()
}
