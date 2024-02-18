//
//  ViewController.swift
//  YYDataBaseCenter
//
//  Created by HarrisonFu on 2024/1/26.
//

import UIKit
import FMDB
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        YYDatabaseCenter.initDatabase()
        NTUIDebugPrint("======= Begin save models000")
//        DispatchQueue.global().async {
//            var models = [YYGlobalUserDefault]()
//            for i in 0 ... 500 {
//                let model = YYGlobalUserDefault()
//                model.identifier = "key11:\(i)" //when in testing, then identifier should be different.
//                model.val = "\(i)"
//                model.val1 = "\(i)"
//                model.val2 = "\(i)"
//                model.val3 = "\(i)"
//                model.val4 = "\(i)"
//                models.append(model)
//            }
//            YYDatabaseCenter.save(models) { success, error in
//                NTUIDebugPrint("success: \(success) -- error: \(String(describing: error))")
//            }
//        }
        NTUIDebugPrint("======= Begin save models1111")

//        YYDatabaseCenter.asyncSaveModel(models: models) { error in
//            NTUIDebugPrint("======= end save models: \(String(describing: error))")
//        }
//        var model = YYDatabaseCenter.read(aClass: YYGlobalUserDefault.self, primaryKey: "key4:5000")
//        NTUIDebugPrint("=======model0: \(String(describing: model))")
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//            model = YYDatabaseCenter.read(aClass: YYGlobalUserDefault.self, primaryKey: "key4:5000")
//            NTUIDebugPrint("=======model1: \(String(describing: model))")
//        }
        
//

        YYGlobalUserDefault.update(key: .test, val: "HELLLO LingLing, How are you?") { s , e in
            NTUIDebugPrint("=======did update ====")
            YYGlobalUserDefault.getUserDefalt(key: .test) { val, err in
                NTUIDebugPrint("=======did get: \(val?.val ?? "Error") ====")
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            YYGlobalUserDefault.remove(key: .test) { s, e in
                NTUIDebugPrint("=======did  remove====")
            }
        }
    }


}


public func NTUIDebugPrint(_ obj:Any?,
                         mark:String = "==ui==",
                         filePath: StaticString = #file,
                         function:StaticString = #function,
                         rowCount: Int = #line) {
#if DEBUG
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM-dd HH:mm:ss:SSS"
    let dateStr = dateFormatter.string(from: Date())
    
    var _filePath = filePath.description
    var fileName = _filePath.components(separatedBy: "/").last ?? ""
    if let range = fileName.range(of: ".swift") {
        fileName.replaceSubrange(range, with: "")
    }
    
    let message = "[" + dateStr + "]" + "[" + fileName + " " + "Row:" + "\(rowCount)" + "]"
    let header = "\(message) uiDebugPrint \(mark): "
    
    if let obj = obj as? CGRect {
        print("\(header)(x:\(obj.minX), y:\(obj.minY), w:\(obj.width), h:\(obj.height))")
    } else if let obj = obj as? String {
        print("\(header)\(obj)")
    } else {
        print("\(header)\(obj ?? "nil")")
    }
#else
    if let obj = obj as? CGRect {
        debugPrint("(x:\(obj.minX), y:\(obj.minY), w:\(obj.width), h:\(obj.height))")
    } else if let obj = obj as? String {
        debugPrint("\(obj)")
    } else {
        debugPrint("\(obj ?? "nil")")
    }
#endif
}
