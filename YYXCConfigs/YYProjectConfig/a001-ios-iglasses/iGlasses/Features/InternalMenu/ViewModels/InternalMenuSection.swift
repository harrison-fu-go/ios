//
//  InternalMenuSection.swift
//  iGlasses
//
//  Created by Matthew on 2021/4/13.
//

import Foundation

protocol SectionModelType {
}

struct InternalMenuSection: SectionModelType {
    let title: String
    let items: [InternalMenuItemViewModel]
    let footer: String?

    init(title: String, items: [InternalMenuItemViewModel], footer: String? = nil) {
        self.title = title
        self.items = items
        self.footer = footer
    }

    init(original: InternalMenuSection, items: [InternalMenuItemViewModel]) {
        self.init(title: original.title, items: items, footer: original.footer)
    }
}
