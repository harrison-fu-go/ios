//
//  DatabaseConstants.swift
//  iGlasses
//
//  Created by zk-fuhuayou on 2021/5/14.
//

import Foundation

//swiftlint:disable comma
struct DatabaseConstants {
    
    //tables:
    //table names
    static let appInfoRecordsTable = "AppInfoRecords"
    static let globalRecords = "globalRecords"
    static let tablesInfo = [
        
        //table: AppInfoRecords
        globalRecords : [
            ["id" , "INTEGER" , "NOT NULL PRIMARY KEY AUTOINCREMENT", "false"], //false: whether need base64 encoding. = false.
            ["global_key" , "TEXT" , "NOT NULL UNIQUE", "false"],
            ["global_value" , "TEXT" , "", "true"],
            ["udpateTs" , "INTEGER" , "", "false"]
        ],
        
        //table: AppInfoRecords
        appInfoRecordsTable : [
            ["id" , "INTEGER" , "NOT NULL PRIMARY KEY AUTOINCREMENT", "false"], //false: whether need base64 encoding. = false.
            ["latestVersion" , "TEXT" , "", "false"],
            ["versionCode" , "INTEGER" , "NOT NULL UNIQUE", "false"],
            ["linkAppStore" , "TEXT" , "", "true"],
            ["updateDesc" , "TEXT" , "", "true"],
            ["forceUpdate" , "TEXT" , "", "false"],
            ["udpateTs" , "INTEGER" , "", "false"]
        ]]
    
    static func columns(of table: String) -> [String] {
        let tableInfo = tablesInfo[table] ?? []
        var icolumns = [String]()
        for column in tableInfo {
            icolumns.append(column[0])
        }
        return icolumns
    }
    
    static func columnContent(of table: String, column: String) -> [String] {
        let tableInfo = tablesInfo[table] ?? []
        for iColumn in tableInfo where iColumn[0] == column {
            return iColumn
        }
        return []
    }
}
