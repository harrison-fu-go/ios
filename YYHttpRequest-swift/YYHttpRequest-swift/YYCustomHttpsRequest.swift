//
//  YYCustomHttpsRequest.swift
//  YYHttpRequest-swift
//
//  Created by HarrisonFu on 2024/2/23.
//

import Foundation
import Alamofire

enum YYHttpMehod: String {
    case GET = "GET"
    case POST = "POST"
}

class YYCustomHttpsRequest  {
    
    static func request(httpMethod: YYHttpMehod,
                        urlStr: String,
                        parameters: [String:Any]? = nil,
                        resultCallback: ((Result<Any, Error>) -> Void)? = nil) {
        guard let url = URL(string: urlStr) else { return } //url
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        request.httpBody = self.parametersStr(parameters: parameters)?.data(using: .utf8)
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest) { data, response, error in
            if let error = error {
                resultCallback?(.failure(error))
            } else {
                var code = -10000
                if let res = response as? HTTPURLResponse {
                    code = res.statusCode
                }
                
                if code >= 200, code < 300 {
                    let jsonResult = JSON(data)
                    resultCallback?(.success(jsonResult))
                } else {
                    resultCallback?(.failure(YYHttpError(httpCode:code)))
                }
            }
            if let response = response {
                print("===== NETWORK PRTINT RESPONSE: \(response)")
            }
            if let data = data  {
                print("===== NETWORK PRTINT DATA: \(JSON(data))")
            }
            if let error = error {
                print("===== NETWORK PRTINT ERROR: \(error)")
            }
        }
        dataTask.resume()
    }
    
    static func parametersStr(parameters:[String:Any]?) -> String? {
        guard let parameters = parameters, parameters.count > 0  else { return nil }
        var parameterStr = ""
        parameters.enumerated().forEach { index, KV in
            let keyValue = "\(KV.key)=\(KV.value)"
            let isSide = index == 0 || index == parameters.count
            parameterStr = isSide ? (parameterStr + keyValue) : (parameterStr + "&" + keyValue)
        }
        print("===== NETWORK PRTINT PARAMETERS: \(parameterStr)")
        return parameterStr
    }
}

struct YYHttpError: Error {
    var httpCode: Int
    var message: String = "Code not right"
    var errCode: Int = -20000
}
