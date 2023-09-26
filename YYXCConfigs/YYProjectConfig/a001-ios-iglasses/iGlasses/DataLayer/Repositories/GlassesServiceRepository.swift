//
//  GlassesServiceRepository.swift
//  iGlasses
//
//  Created by Matthew on 2021/4/24.
//

import Foundation
import Alamofire
import Moya
import RxSwift

enum GlassesServiceApi {
    case checkAppVersion(version:String, code: Int)
    case checkFirmwareVersion(version:String, code: Int)
    case downloadFirmware(url:String)
    case appRemoteConfig(version:String)
    case guide(language: String, skipNum: Int, length: Int)
}

extension GlassesServiceApi: TargetType {
    
    
    var baseURL: URL {
        if GlassesUnitTest.enable {
            switch self {
            case let .downloadFirmware(url):
                // swiftlint:disable force_unwrapping
                return URL(string: url)!
            default:
                return API.baseURL
            }
        }
        switch self {
        case let .downloadFirmware(url):
            // swiftlint:disable force_unwrapping
            return URL(string: url)!
        default:
            return API.baseURL
        }
    }
    
    var path: String {
        switch self {
        case .checkAppVersion:
            return "/api/app_update"
        case .appRemoteConfig:
            return "/api/app_config"
        case .checkFirmwareVersion:
            return "/api/firmware_update"
        case .downloadFirmware:
            return ""
        case .guide:
            return "/api/guide"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .checkAppVersion,
             .appRemoteConfig,
             .checkFirmwareVersion,
             .downloadFirmware,
             .guide:
            return .get
        }
    }
    
    var sampleData: Data {
        var json: String!
        switch self {
        case .appRemoteConfig:
            json =
                """
                {
                    "code": 1,
                    "data": {
                        "isAppStoreReviewing": false,
                    },
                    "message": "Success"
                }
                """
        case .checkAppVersion:
            json =
                """
                {
                    "code": 1,
                    "message": "success",
                    "data": {
                        "latestVersion": "1.0.1",
                        "versionCode": 2,
                        "linkAppStore": "https://apps.apple.com/cn/app/id590338362",
                        "updateDesc": "2021.5.13版本更新 1、调整蓝牙稳定性  2、bug fix 3、功能微调 ",
                        "forceUpdate": true
                    }
                }
                """
        case .checkFirmwareVersion:
            json =
                """
                {
                    "code":1,
                    "message":"success",
                    "data":{
                        "code":1,
                        "lastestVersion":"1.0.0",
                        "downloadLink":"http://www.zkyg.com/ios/iglass.ipa"
                    }
                }
                """
        case .guide,
             .downloadFirmware:
            return Data()
        }
        // swiftlint:disable force_unwrapping
        return json.data(using: .utf8)!
    }
    
    var task: Task {
        var params: [String: Any]!
        switch self {
        case let .checkAppVersion(version, code):
            params = ["version": version, "code": code]
        case .appRemoteConfig(let version):
            params = ["version": version]
        case let .checkFirmwareVersion(version, code):
            params = ["version": version, "code": code]
        case .downloadFirmware:
            return .downloadDestination(DownloadRequest.suggestedDownloadDestination(options: [.removePreviousFile]))
        case let .guide(language, skipNum, length):
            params = ["language": language, "skipNum": skipNum, "length": length, "order": "asc"]
        }
        return .requestParameters(parameters: params, encoding: URLEncoding.default)
    }
    
    var headers: [String : String]? {
        return [
            "x-app-platform": "ios",
            "x-app-version": UIApplication.appVersion,
            "x-os-version": UIDevice.current.systemVersion
        ]
    }
}

protocol GlassesRemoteService {
    func checkAppVersion(_ version: String, code: Int) -> Single<AppVersion>
    
    func checkFirmwareVersion(_ version: String, code: Int) -> Single<FirmwareVersion>
    
    func downloadFile(url: String) -> Observable<ProgressResponse>
    
    func requestAppRemoteConfig(version: String) -> Single<AppRemoteConfig>
    
    func fetchGuideList(language: String, skipNum: Int, length: Int) -> Single<[GuideSection]?>
}


class GlassesRemoteServiceImpl {
    let serialQueue = DispatchQueue(label: "zkyg.iglasses.app.api.serial", qos: .background)
    let concurrentQueue = DispatchQueue(label: "zkyg.iglasses.app.api", qos: .background, attributes: .concurrent)
    
    private let _provider: MoyaProvider<GlassesServiceApi>
    
    var provider: MoyaProvider<GlassesServiceApi> {
        _provider
    }
    
    init(test: Bool = false) {
        var stubClosure: MoyaProvider<GlassesServiceApi>.StubClosure!
        if test {
            stubClosure = MoyaProvider.immediatelyStub
        } else {
            stubClosure = MoyaProvider.neverStub
        }
        #if DEBUG
        _provider = MoyaProvider<GlassesServiceApi>(stubClosure: stubClosure,
                                                    plugins: [
                                                        NetworkLoggerPlugin(
                                                            configuration: .init(formatter: .init(responseData: GlassesRemoteServiceImpl.JSONResponseDataFormatter),
                                                                                 logOptions: .verbose))
                                                    ])
        #else
        _provider = MoyaProvider<GlassesServiceApi>(plugins: [NetworkLoggerPlugin()])
        #endif
    }
    
    private static func JSONResponseDataFormatter(_ data: Data) -> String {
        do {
            let dataAsJSON = try JSONSerialization.jsonObject(with: data)
            let prettyData = try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
            return String(data: prettyData, encoding: .utf8) ?? String(data: data, encoding: .utf8) ?? ""
        } catch {
            return String(data: data, encoding: .utf8) ?? ""
        }
    }
    
    private func rxCompactRequest<R: Codable>(target: GlassesServiceApi) -> Single<R> {
        return self.provider.rx.request(target, callbackQueue: concurrentQueue)
            .do(onError: {
                throw DataError.network(description: $0.localizedDescription)
            })
            .map(GeneralResponse<R>.self)
            .do(onSuccess: {
                if $0.code != 1 {
                    throw DataError.responseError(data: ResponseError(code: $0.code, message: $0.message))
                }
            }, onError: {
                throw DataError.dataCorrupt(description: $0.localizedDescription)
            })
            .map {
                $0.data!
            }
            .observe(on: MainScheduler.instance)
    }
    
    private func rxRequest<R: Codable>(target: GlassesServiceApi) -> Single<R?> {
        return self.provider.rx.request(target, callbackQueue: concurrentQueue)
            .do(onError: {
                throw DataError.network(description: $0.localizedDescription)
            })
            .map(GeneralResponse<R>.self)
            .do(onSuccess: {
                if $0.code != 1 {
                    throw DataError.responseError(data: ResponseError(code: $0.code, message: $0.message))
                }
            }, onError: {
                throw DataError.dataCorrupt(description: $0.localizedDescription)
            })
            .map {
                $0.data
            }
            .observe(on: MainScheduler.instance)
    }
    
}

extension GlassesRemoteServiceImpl: GlassesRemoteService {
    
    func checkAppVersion(_ version: String, code: Int) -> Single<AppVersion> {
        return rxCompactRequest(target: .checkAppVersion(version: version, code: code))
    }
    
    func checkFirmwareVersion(_ version: String, code: Int) -> Single<FirmwareVersion> {
        return rxCompactRequest(target: .checkFirmwareVersion(version: version, code: code))
    }
    
    func downloadFile(url: String) -> Observable<ProgressResponse> {
        return self.provider.rx.requestWithProgress(.downloadFirmware(url:url), callbackQueue: serialQueue)
    }
    
    func requestAppRemoteConfig(version: String) -> Single<AppRemoteConfig> {
        return rxCompactRequest(target: .appRemoteConfig(version: version))
    }
    
    func fetchGuideList(language: String, skipNum: Int, length: Int) -> Single<[GuideSection]?> {
        return rxRequest(target: .guide(language: language, skipNum: skipNum, length: length))
    }
}
