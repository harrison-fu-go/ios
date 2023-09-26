//
//  GuideRootViewModel.swift
//  iGlasses
//
//  Created by fuhuayou on 2021/4/23.
//

import Foundation
// swiftlint:disable no_hardcoded_strings
struct GuideRootViewModel {
    
    var tblDataSources: [Any]?
    init() {
        tblDataSources = [
            [
                ["type": 0, "image":"connectSmartGlasses", "title":"如何连接智能眼镜"],
                ["type": 1, "image":"example1", "title":"推送管理设置", "smallTitle":"对于信息管理的简单设置..."],
                ["type": 1, "image":"example2", "title":"连接失败处理", "smallTitle":"如果用户再操作过程中出现..."]
            ],
            [
                ["type": 0, "image":"operateSmartGlasses", "title":"如何智能智能眼镜"],
                ["type": 1, "image":"example3", "title":"连接蓝牙操作", "smallTitle":"首先要对设备进行蓝牙连接..."],
                ["type": 1, "image":"example4", "title":"常规功能操作", "smallTitle":"对于设备的一些常规功能的一些操作..."]
            ]
        ]
    }
    
}
