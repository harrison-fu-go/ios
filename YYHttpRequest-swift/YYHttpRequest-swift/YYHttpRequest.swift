//
//  YYHttpRequest.swift
//  YYHttpRequest-swift
//
//  Created by HarrisonFu on 2024/2/19.
//

import Foundation
import Alamofire
public let kRequestFail = "Request Fail."
class YYHttpRequest {
    
    public static func request(url: String,
                               method: HTTPMethod,
                               parameters: [String:Any]? = nil,
                               headers: [String:String]? = nil,
                               complete: @escaping (Result<[String:Any], Error>) -> Void) {
        
        //set headers
        var allHeaders = [String:String]()
        headers?.forEach({ (key, value) in
            allHeaders[key] = value
        })
        let httpHeader = HTTPHeaders(allHeaders)
        
        let _ = AF.request(url,
                                 method: method,
                                 parameters: parameters,
                                 encoding: JSONEncoding.default,
                                 headers: httpHeader).response { response in
            switch response.result {
            case .success(let model):
                if let response = response.response, response.statusCode < 200 || response.statusCode > 300 {
                    complete(.failure(NSError(domain: kRequestFail, code: response.statusCode)))
                    return
                }
                let jsonResult = JSON(model)
                let result:Any = jsonResult.dictionary ?? jsonResult.array ?? jsonResult.data ?? []
                complete(.success(["JSON ANALYSIS MESSAGE": jsonResult.messages, "RESULT": result]))
            case .failure(let error):
                complete(.failure(error))
            }
        }
    }

}







