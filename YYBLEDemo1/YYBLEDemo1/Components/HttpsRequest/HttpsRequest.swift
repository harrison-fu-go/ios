//
//  HttpsRequest.swift
//  YYBLEDemo1
//
//  Created by fuhuayou on 2021/4/12.
//

import Foundation
import Alamofire

class HttpsRequest : NSObject {
    
    /*
     url: url, https://...
     options: headers, body, needToken, timeout, loading
     */
    static func get(url:String,
                    _ parameters:  [String: Any]?,
                    _ completion: (( _ response:[String : Any] ) -> Void)? ) {
        HttpsRequest.singleton.request("GET", url, parameters: parameters, completion)
    }
    
    static func post(url:String,
                     _ parameters:  [String: Any]?,
                     _ completion: (( _ response:[String : Any] ) -> Void)? ) {
        HttpsRequest.singleton.request("POST", url, parameters: parameters, completion)
    }
    
    // singleton
    static let singleton = HttpsRequest();
    private override init() {}
    
    // async tasks.
    var asyncTasks: [String: Any] = [:];
    
    func request(_ method: String, _ url: String, parameters:[String: Any]?, _ completion: (( _ response:[String : Any] ) -> Void)?) {
        
        var timeout:Int = 60
        if let parameters = parameters {
            timeout = (parameters["timeout"] as? Int) ?? 60
            // ...
        }
        
        let htTask = HttpsTask(url:url, method: method, timeout:timeout, completion: completion)
        asyncTasks[url] = htTask
        htTask.resume {
            self.asyncTasks.removeValue(forKey: htTask.url!)
        }
        
        var task: DataRequest?
        switch method {
        case "GET":
            task = AF.request(url, method: .get)
        case "POST":
             task = AF.request(url, method: .post, parameters: parameters)
        default:
            break
        }
        
        if let task = task {
            htTask.afTask = task
            htTask.afTask?.responseJSON(completionHandler: { response in
                var success: Bool?
                var result: Any?
                
                // success.
                if case let Result.success(data) = response.result {
                    success = true
                    result = data
                }
                
                // fail.
                if case let Result.failure(data) = response.result {
                    success = false
                    result = data
                }
                htTask.finished(["success":success!, "code": response.response?.statusCode ?? 0, "body": result ?? ["message":"unknow"]])
                self.asyncTasks.removeValue(forKey: htTask.url!)
            })
        }
    }
    
    
    // aync tasks.
//    var syncTasks: [String: Any] = [:];
//    var isSyncRunning = false
//    func syncRequest(_ method: String, _ url: String, parameters:[String: Any]?, _ completion: (( _ response:[String : Any] ) -> Void)?) {
//
//        var timeout: Int = 60
//        var priority: Int = 0
//        var identifier: String = Date.milliseconds()
//        if let parameters = parameters {
//            timeout = parameters["timeout"] as? Int ?? 60
//            priority = parameters["priority"] as? Int ?? 0
//            identifier = parameters["identifier"] as? String ?? Date.milliseconds()
//        }
//
//        let task = HttpsTask(url:url,
//                             timeout: timeout,
//                             priority: priority,
//                             identifier: identifier,
//                             completion: completion)
//        syncTasks[identifier] = task
//
//        //1. get highest task.
//    }
}
