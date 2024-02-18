//
//  YYDatabaseCenter.swift
//  NTPlatformKit
//
//  Created by HarrisonFu on 2022/4/13.
//

import UIKit
import RealmSwift
public typealias DBOperateCallback<T> = (T, Error?) -> Void
public typealias DBResultsCallback<T:Object> = (Results<T>?, Error?) -> Void
public class YYDatabaseCenter: NSObject {
    private typealias getDBCallback = (Realm?) -> Void
    static let dbThread = Thread(target: YYDatabaseCenter.self, selector: #selector(startDbThreadRunloop), object: nil)
    static var dbName: String {
        return "NTDatabase.realm"
    }
    private static var db: Realm?
    static var dbPath: String {
        let docPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] as String
        let dbPath = docPath.appending("/\(self.dbName)")
        return dbPath
    }
    
    class func initDatabase() {
        dbThread.threadPriority = 0.9
        dbThread.start()
        dbThread.doBlock {
            configDB(completed: nil)
        }
    }
    
    @objc class func startDbThreadRunloop() {
        RunLoop.current.run()
    }
    
    private class func gernarateDB(completed: getDBCallback?) {
        /// configuration, data migration
        if let db = db {
            completed?(db)
            return
        }
        dbThread.doBlock {
            var tRealm: Realm?
            if let url = URL(string: self.dbPath) {
                do {
                    let defaultRealm = try Realm(fileURL: url)
                    self.db = defaultRealm
                    tRealm = defaultRealm
                    self.dbLog(message: "Create Database successfully!", printThread: false)
                } catch {
                    self.dbLog(message: "Create DB error \(error)", printThread: false)
                }
            }
            completed?(tRealm)
        }
    }
    
    private class func dbLog(message: String, printThread: Bool = false) {
        if printThread {
            print("****** DB LOG: \(message) ****** Current Thread: \(Thread.current)")
        } else {
            print("****** DB LOG: \(message) ******")
        }
    }
}

public extension YYDatabaseCenter {
    
    /// 配置数据库
    @objc class func configDB(completed: DBOperateCallback<Bool>?) {
        /// 如果要存储的数据模型属性发生变化,需要配置当前版本号比之前大
        let dbVersion : UInt64 = 8
        
        let config = Realm.Configuration(fileURL: URL.init(string: self.dbPath), inMemoryIdentifier: nil, syncConfiguration: nil, encryptionKey: nil, readOnly: false, schemaVersion: dbVersion, migrationBlock: { (migration, oldSchemaVersion) in
            /**数据迁移放这里**/
             //migration.enumerateObjects(ofType: DownloadOTAModel.className(), { (oldObject, newObject) in })
        }, deleteRealmIfMigrationNeeded: true/* for crash issue */, shouldCompactOnLaunch: nil, objectTypes: nil)
        Realm.Configuration.defaultConfiguration = config
        Realm.asyncOpen { result in
            self.dbLog(message:"result = \(result)")
            if result is Swift.Error {
                self.dbLog(message:"Realm Init config error!")
                dbThread.doBlock {
                    completed?(false, nil)
                }
            } else {
                self.dbLog(message:"Realm Init config successfully!")
                dbThread.doBlock {
                    completed?(true, nil)
                }
            }
        }
    }
}

public extension YYDatabaseCenter {
    
    private class func prepareExecute(endCall:DBOperateCallback<Bool>? = nil,
                                      isWrite: Bool = true,
                                      errorMess: String = "DB Error",
                                      excute:@escaping (Realm) -> Void) {
        self.gernarateDB { realm in
            self.dbThread.doBlock {
                guard let realm = realm else {
                    guard let endCall = endCall else {
                        self.dbLog(message: "realm = nil.")
                        return
                    }
                    endCall(false, DBError(errorMessage: "realm = nil."))
                    return
                }
                if isWrite {
                    do {
                        try realm.write {
                            excute(realm)
                            endCall?(true, nil)
                        }
                    } catch {
                        self.dbLog(message:"\(errorMess): \(error)")
                        endCall?(false, error)
                    }
                } else {
                    excute(realm)
                }
            }
        }
    }
}

/// add
public extension YYDatabaseCenter {
    class func save(_ model: Object, completed: DBOperateCallback<Bool>? = nil) {
        self.save([model], completed: completed)
    }

    class func save(_ models: [Object], completed: DBOperateCallback<Bool>? = nil) {
        self.prepareExecute(endCall: completed, errorMess: "Save Error") { realm in
            realm.add(models)
        }
    }
}

//get
public extension YYDatabaseCenter {
    class func read(aClass: Object.Type, primaryKey: String, readCompleted: @escaping DBOperateCallback<Object?>) {
        self.prepareExecute(isWrite: false) { defaultRealm  in
            let predicate = NSPredicate(format: "identifier = %@", primaryKey)
            let result = defaultRealm.objects(aClass.self)
            readCompleted(result.filter(predicate).first, nil)
        }
    }
	
    class func allObjects<T:Object>(aClass:T.Type, result:@escaping DBResultsCallback<T>) {
        self.prepareExecute(isWrite: false) { defaultRealm  in
            result(defaultRealm.objects(aClass), nil)
        }
	}
}

//update
public extension YYDatabaseCenter {
    class func update(aClass: Object.Type, 
                      primaryKey: String,
                      updateBlock: @escaping (_ obj:Object) -> Void) {
        self.prepareExecute(isWrite: false, errorMess: "Update Error") { realm in
            let predicate = NSPredicate(format: "identifier = %@", primaryKey)
            let result = realm.objects(aClass.self)
            if let obj = result.filter(predicate).first {
                try! realm.write {
                    updateBlock(obj)
                }
            }
        }
    }
    
    class func safeUpdate(updateBlock: @escaping () -> Void) {
        self.prepareExecute(errorMess: "SafeUpdate Error") { realm in
            updateBlock()
        }
    }
	
	class func updateModel(model: Object, completed: DBOperateCallback<Bool>? = nil) {
        self.prepareExecute(endCall: completed, errorMess: "UpdateModel Error") { realm in
            realm.add(model, update: .all)
        }
	}
}

//delete
public extension YYDatabaseCenter {
    
    class func delete(model:Object, completed: DBOperateCallback<Bool>? = nil) {
        self.prepareExecute(endCall: completed) { defaultRealm  in
            defaultRealm.delete(model)
        }
    }
    
    class func delete(models:[Object], completed: DBOperateCallback<Bool>? = nil) {
        self.prepareExecute(endCall: completed) { defaultRealm  in
            defaultRealm.delete(models)
        }
    }
    
    class func delete(aClass:Object.Type, primaryKey:String, completed: DBOperateCallback<Bool>? = nil) {
        self.read(aClass: aClass, primaryKey: primaryKey) { obj, error in
            if let model = obj {
                self.prepareExecute { defaultRealm in
                    defaultRealm.delete(model)
                    completed?(true, nil)
                }
            } else {
                completed?(false, DBError(errorMessage: "Obj not exist"))
            }
        }
    }

    class func deleteAll(aClass:Object.Type, completed: DBOperateCallback<Bool>? = nil) {
        self.allObjects(aClass: aClass) { results, error in
            if let models = results {
                self.prepareExecute { defaultRealm in
                    defaultRealm.delete(models)
                    completed?(true, nil)
                }
            } else {
                completed?(false, DBError(errorMessage: "DeleteAll Objs Error"))
            }
        }
    }
}

public extension YYDatabaseCenter {
    /**
       The clolum of the key must be number type
     */
    static func incrementalID(aClass:
                              Object.Type, key:String,
                              completed:@escaping DBOperateCallback<Int64>) {
        self.prepareExecute(isWrite: false) { defaultRealm in
            let objects = defaultRealm.objects(aClass).sorted(byKeyPath: key, ascending: true)
            if let last = objects.last {
                var index:Int64 = 0
                if let val = last.value(forKey: key) as? String {
                    index = (Int64(val) ?? 0) + 1
                }
                if let val = last.value(forKey: key) as? Int64 {
                    index = val + 1
                }
                completed(index, nil)
            } else {
                completed(0, nil)
            }
        }
    }
}

//MARK: LIST
public extension List {
    func safe_append(object: Element) {
        YYDatabaseCenter.safeUpdate {
            self.append(object)
        }
    }
    
    func safe_remove(index:Int) {
        YYDatabaseCenter.safeUpdate {
            self.remove(at: index)
        }
    }
    
    func safe_removeAll() {
        YYDatabaseCenter.safeUpdate {
            self.removeAll()
        }
    }
}

struct DBError: Error {
    var domain: String = "DB.Error.Domain"
    var code: Int = 4444
    var errorMessage: String = "DB Error"
}

/**
 Thread extension methods for data base center.
 */
extension Thread {
    
    func doBlock(completed: @escaping () -> Void) {
        let block: @convention(block) () -> () = completed
        self.perform(#selector(executeOnDbThread), on: self, with: block, waitUntilDone: false)
    }
    
    @objc func executeOnDbThread(completed: @escaping () -> Void) {
        completed()
    }
    
}
