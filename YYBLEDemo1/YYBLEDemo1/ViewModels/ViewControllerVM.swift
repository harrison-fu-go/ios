//
//  ViewControllerVM.swift
//  YYBLEDemo1
//
//  Created by yy.Fu on 2021/3/30.
//

import Foundation
import RxSwift

struct ViewControllerVM {
    var data = Observable<Array>.just([["name": "无条件", "singer": "学友哥"],
                                ["name": "Hello", "singer": "陈奕迅"]])
//    init() {
//        changeData();
//    }
//
//    mutating func changeData() -> Void {
//
//        DispatchQueue.global().asyncAfter(deadline: .now() + 10) {
//            self.data = Observable.from(optional: [["name": "相思风雨中", "singer": "学友哥"],
//                                    ["name": "阿牛", "singer": "陈奕迅"]])
//        }
//    }
}
