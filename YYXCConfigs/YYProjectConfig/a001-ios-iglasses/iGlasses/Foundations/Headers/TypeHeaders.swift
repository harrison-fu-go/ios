//
//  TypeHeaders.swift
//  iGlasses
//
//  Created by zk-fuhuayou on 2021/5/28.
//

import Foundation


typealias ProgressCallback = (Bool, Int, String) -> Void
typealias ProgressDoubleCallback = (Bool, Double, String) -> Void
typealias GetCallback<T> = (Bool, T, String) -> Void
typealias SetCallback<T> = (Bool, T, Error) -> Void
typealias ZKCallback<T> = (T) -> Void

//progress.
enum SuccessFlag {
    case noStart
    case onGoing
    case complete
    case error
    case timeout
}
typealias ProgressValue = Double
struct ProgressHandle {
    init(state: SuccessFlag = .complete, progress:ProgressValue = 0, message:String? = nil, error:NSError? = nil) {
        self.state = state
        self.progress = progress
        self.message = message
        self.error = error
    }
    var state: SuccessFlag = .noStart
    var progress: ProgressValue = 0
    var error: NSError?
    var message: String?
}
