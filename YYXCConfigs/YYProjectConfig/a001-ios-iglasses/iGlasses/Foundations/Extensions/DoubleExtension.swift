//
//  DoubleExtension.swift
//  iGlasses
//
//  Created by fuhuayou on 2021/4/21.
//

import Foundation


extension Double {
    
    //保留n位小数点
    func roundTo(bits:Int) -> Double {
        let divisor = pow(10.0, Double(bits))
        return (self * divisor).rounded() / divisor
    }

}
