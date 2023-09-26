//
//  API.swift
//  iGlasses
//
//  Created by Matthew on 2021/4/16.
//

import Foundation

enum API {
    // swiftlint:disable force_try force_unwrapping
    static let baseURL = try! URL(string: "http://" + Configuration.value(for: "API_BASE_URL"))!
}
