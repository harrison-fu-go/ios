//
//  DatabaseProtocols.swift
//  iGlasses
//
//  Created by zk-fuhuayou on 2021/5/14.
//

import Foundation

//App info.
protocol AppInfoDBOperateProtocol {
    func updateAppInfo(_ appInfoModel: DatabaseModel)
    func getLatestAppInfo() -> DatabaseModel?
}
