//
//  DataError.swift
//  iGlasses
//
//  Created by Matthew on 2021/4/16.
//

import Foundation

enum DataError: Error {
  case dataCorrupt(description: String)
  case localPubKeyNotExists
  case fileNotExist
  case any
  case network(description: String)
  case responseError(data: ResponseError)
}

//public enum ApiError: Swift.Error, CustomStringConvertible {
//    case noError
//    case decryptError
//    case platformError(String)
//    case jsonParseError
//    case serverError(String)
//    case unknowError
//
//    public var description: String {
//        switch self {
//        case .noError:
//            return ""
//        case .decryptError:
//            return "数据解密失败"
//        case let .platformError(error):
//            return error
//        case .jsonParseError:
//            return "数据解析(解密)失败"
//        case let .serverError(error):
//            print(error)
//            return "网络超时或错误，请稍后重试"
//        case .unknowError:
//            return "未定义错误"
//        }
//    }
//}
