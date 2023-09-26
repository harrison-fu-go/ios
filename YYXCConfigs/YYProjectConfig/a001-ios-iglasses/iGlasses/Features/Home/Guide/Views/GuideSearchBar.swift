//
//  GuideSearchBar.swift
//  iGlasses
//
//  Created by fuhuayou on 2021/4/23.
//

import UIKit

class GuideSearchBar: UISearchBar {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.placeholder = "搜索"
        self.searchBarStyle = .minimal
    }
    
//    override func draw(_ rect: CGRect) {
//
//    }
//
//    override func didMoveToSuperview() {
//
//    }
}
