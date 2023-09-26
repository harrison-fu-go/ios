//
//  DatabaseCenter.swift
//  iGlasses
//
//  Created by zk-fuhuayou on 2021/5/13.
//

import Foundation
import FMDB
//swiftlint:disable force_unwrapping
class DatabaseCenter: NSObject {
    
    //singleton
    static let sharedInstance = DatabaseCenter()
    
    //database
    let dataBaseQueue = DispatchQueue(label: "DatabaseCenterSyncQueue")
    let dataBase:FMDatabase
    
    //
    override init() {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! + "/holoever.sqlite"
        self.dataBase = FMDatabase(path: path)
        super.init()
        //create tables
        self.createTables()
    }
    
    func tableSqls() -> String {
        //create tables
        var tablesSql = ""
        for (tableName, tableInfo) in DatabaseConstants.tablesInfo {
            var sql = "CREATE TABLE IF NOT EXISTS `\(tableName)` ( "
            for columns in tableInfo {
                sql += columns[0] + "    " + columns[1] + " " + columns[2] + ","
            }
            sql = String(sql.dropLast())
            sql += "); "
            tablesSql += sql
        }
        return tablesSql
    }
    
    func createTables() {
        self.dataBaseQueue.sync {
            if self.dataBase.open() {
                print("====== DATABASE OPENED ======")
                let sql = self.tableSqls()
                let result = self.dataBase.executeStatements(sql)
                print("====== DATABASE CREATE TABLES: ", result)
            }
        }
    }
    
    func executeUpdate(sql:String) -> Bool {
        DispatchQueue.global().sync {
            self.dataBaseQueue.sync {
                do {
                    try self.dataBase.executeUpdate(sql, values:nil)
                } catch {
                    print("============== DB EXEC UPDATE ERROR: ", error)
                    return false
                }
                return true
            }
        }
    }
    
    func executeQuery(sql:String) -> FMResultSet? {
        DispatchQueue.global().sync {
            self.dataBaseQueue.sync {
                var val:FMResultSet?
                do {
                    try val = self.dataBase.executeQuery(sql, values: nil)
                } catch {
                    print("============== DB EXEC QUERY ERROR: ", error)
                    val = nil
                }
                return val
            }
        }
    }
}

extension DatabaseCenter : AppInfoDBOperateProtocol {
    
    func updateAppInfo(_ appInfoModel: DatabaseModel) {
        let sql = self.generateUpdateSql(tableName: DatabaseConstants.appInfoRecordsTable,
                                         headerSql: "insert or replace into",
                                         taskModel: appInfoModel)
        let result = self.executeUpdate(sql: sql)
        if !result {
            print("============== updateAppInfo ERROR =============")
        }
    }
    
    func getLatestAppInfo() -> DatabaseModel? {
        let sql = "SELECT * FROM \(DatabaseConstants.appInfoRecordsTable) order by versionCode desc limit 1;"
        let models = self.queryDatabaseModel(table: DatabaseConstants.appInfoRecordsTable, sql: sql)
        if models.isEmpty {
            return nil
        }
        return models[0]
    }
    
    func generateUpdateSql(tableName:String, headerSql: String, taskModel:DatabaseModel) -> String {
        var sql = headerSql + " \(tableName) ("
        var valueSql = "("
        let columns = DatabaseConstants.columns(of: tableName)
        for column in columns {
            if column == "id" {
                continue
            }
            sql += (column + " , ")
            
            if column == "udpateTs" {
                let ts = Int64(Date().timeIntervalSince1970 * 1000)
                valueSql += "'" + String(ts) + "', "
                continue
            }
            let isNeedEncode = DatabaseConstants.columnContent(of: tableName, column: column)[3] == "true"
            let value = taskModel.associateValue(key: column) ?? ""
            valueSql += "'" + (isNeedEncode ? value.base64Encoding() : value) + "', "
        }
        var sqls = Array(sql)
        sqls.removeSubrange((sqls.count - 3) ..< sqls.count)
        sql = String(sqls) + ") values "
        
        var valueSqls = Array(valueSql)
        valueSqls.removeSubrange((valueSqls.count - 2) ..< valueSqls.count)
        valueSql = String(valueSqls) + ")"
        let totalSql = sql + valueSql
        return totalSql
    }
    
    func queryDatabaseModel(table: String, sql:String) -> [DatabaseModel] {
        let result = DatabaseCenter.sharedInstance.executeQuery(sql: sql)
        var models = [DatabaseModel]()
        if let result = result {
            let columns = DatabaseConstants.columns(of:table)
            while result.next() {
                let model = DatabaseModel()
                for column in columns {
                    let columnInfo = DatabaseConstants.columnContent(of: table, column: column)
                    let isNeedDecode = columnInfo[3] == "true"
                    var value:String
                    if columnInfo[1] == "INTEGER" {
                        value = String(result.longLongInt(forColumn: column))
                    } else {
                        value = result.string(forColumn: column) ?? ""
                    }
                    if isNeedDecode {
                        value = value.base64Decoding()
                    }
                    model.setAssociateValue(key: column, value: value)
                }
                models.append(model)
            }
        }
        return models
    }
}

extension DatabaseCenter {
    static func updateGlobalValue(key:String, value:String?) {
        var sql:String
        if value == nil {
            sql = "delete from \(DatabaseConstants.globalRecords) where global_key = '\(key)'"
        } else {
            let model = DatabaseModel()
            model.associateCopy(valMap: ["global_key": key, "global_value": value!])
            sql = DatabaseCenter.sharedInstance.generateUpdateSql(tableName: DatabaseConstants.globalRecords,
                                                                      headerSql: "insert or replace into", taskModel: model)
        }
        let result = DatabaseCenter.sharedInstance.executeUpdate(sql: sql)
        if !result {
            print("============== updateGlobalValue ERROR =============")
        }
    }
    
    static func globalValue(key:String) -> String? {
        let sql = "SELECT * FROM \(DatabaseConstants.globalRecords) where global_key = '\(key)'"
        let models = DatabaseCenter.sharedInstance.queryDatabaseModel(table: DatabaseConstants.globalRecords, sql: sql)
        if models.isEmpty {
            return nil
        }
        var result:String?
        let model = models[0]
        result = model.associateValue(key: "global_value")
        return result
    }
}
