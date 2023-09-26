//
//  InternalMenuDesignKitDemoItemViewModel.swift
//  iGlasses
//
//  Created by Matthew on 2021/4/13.
//

import Foundation

final class InternalMenuDesignKitDemoItemViewModel: InternalMenuActionTriggerItemViewModel {
    private let responder: DesignDemoResponder

    init(responder: DesignDemoResponder) {
        self.responder = responder
    }

    override var title: String {
        return L10n.InternalMenu.designDemo
    }

    override func select() {
        responder.designDemo()
    }
}
