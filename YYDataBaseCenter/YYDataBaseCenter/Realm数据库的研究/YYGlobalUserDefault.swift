//
//  YYGlobalUserDefault.swift
//  Alamofire
//
//  Created by HarrisonFu on 2023/2/13.
//

import UIKit
import RealmSwift

public enum GlobalUserDefaultKey : String {
    case test = "Test"
}

public class YYGlobalUserDefault: Object {
    
    @objc dynamic public var identifier = ""
    @objc dynamic public var val = ""
    @objc dynamic public var val1 = ""
    @objc dynamic public var val2 = ""
    @objc dynamic public var val3 = ""
    @objc dynamic public var val4 = ""
    @objc dynamic public var val5 = ""
    @objc dynamic public var val6 = ""
    @objc dynamic public var val7 = ""
    @objc dynamic public var val8 = ""
    @objc dynamic public var val9 = ""
    @objc dynamic public var val10 = ""
    public override class func primaryKey() -> String? {
        return "identifier"
    }
    
    public class func update(key:GlobalUserDefaultKey, 
                             subKey:String? = nil, val:String,
                             end: DBOperateCallback<Bool>? = nil) {
        let model = YYGlobalUserDefault()
        model.identifier = "\(key.rawValue)\(subKey ?? "")"
        model.val = val
        YYDatabaseCenter.updateModel(model: model, completed: end)
    }
    
    public class func getUserDefalt(key:GlobalUserDefaultKey, 
                                    subKey:String? = nil,
                                    completed:@escaping DBOperateCallback<YYGlobalUserDefault?>) {
        let identifier = "\(key.rawValue)\(subKey ?? "")"
        YYDatabaseCenter.read(aClass: YYGlobalUserDefault.self, primaryKey: identifier) { model, error  in
            completed(model as? YYGlobalUserDefault, error)
        }
    }
    
    public class func remove(key:GlobalUserDefaultKey, 
                             subKey:String? = nil,
                             end: DBOperateCallback<Bool>? = nil) {
        let identifier = "\(key.rawValue)\(subKey ?? "")"
        YYDatabaseCenter.delete(aClass: YYGlobalUserDefault.self, primaryKey: identifier, completed: end)
    }
}

public extension YYGlobalUserDefault {
    
//    public class func generateSubkey(key:String, index:Int) -> String {
//        return "\(key)&&&&&&&&\(index)"
//    }
//    
//    public class func analysisSubkey(subKey:String) -> (key:String?, index: Int) {
//        let subs = subKey.ntc.split(of: "&&&&&&&&")
//        if subs.count < 2 {
//            return (nil, 0)
//        }
//        return (subs[0], Int(subs[1]) ?? 0)
//    }
}

