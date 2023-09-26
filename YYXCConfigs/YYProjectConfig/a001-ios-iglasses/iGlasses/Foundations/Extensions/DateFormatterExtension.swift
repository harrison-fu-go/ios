//
//  DateFormatterExtension.swift
//  iGlasses
//
//  Created by Matthew on 2021/4/16.
//

import Foundation

extension DateFormatter {
  static let mysql: DateFormatter = {
    let formatter = DateFormatter()
    // 2020-05-04 15:18:51
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    return formatter
  }()

  static let normal: DateFormatter = {
    let formatter = DateFormatter()
    // 09/28/2020
    formatter.dateFormat = "MM/dd/yyyy"
    return formatter
  }()
}
