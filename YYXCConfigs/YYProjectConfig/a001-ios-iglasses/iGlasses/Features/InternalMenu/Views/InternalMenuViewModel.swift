//
//  InternalMenuViewModel.swift
//  iGlasses
//
//  Created by Matthew on 2021/4/13.
//

import Foundation
import RxSwift

protocol InternalMenuViewModelType {
    var title: String { get }
    var sections: [InternalMenuSection] { get }
}

struct InternalMenuViewModel: InternalMenuViewModelType {
    let title = L10n.InternalMenu.forbiddenArea
    var sections: [InternalMenuSection] = []

    var viewStatus: Observable<InternalViewResponder> {
      return viewSubject.asObservable()
    }

//    private let viewSubject = BehaviorSubject<InternalViewResponder>(value: .none)
    private let viewSubject = PublishSubject<InternalViewResponder>()

    init() {
        let appVersion = "\(L10n.InternalMenu.version) \((Bundle.main.object(forInfoDictionaryKey: L10n.InternalMenu.cfBundleVersion) as? String) ?? "1.0")"

        let infoSection = InternalMenuSection(
            title: L10n.InternalMenu.generalInfo,
            items: [InternalMenuDescriptionItemViewModel(title: appVersion)]
        )

        let designKitSection = InternalMenuSection(
            title: L10n.InternalMenu.designElement,
            items: [InternalMenuDesignKitDemoItemViewModel(responder: self)])

        let featureTogglesSection = InternalMenuSection(
            title: L10n.InternalMenu.featureToggles,
            items: [
                InternalMenuFeatureToggleItemViewModel(title: L10n.InternalMenu.testButtonEnabled, toggle: InternalToggle.isTestButtonEnabled)
            ])

        let toolsSection = InternalMenuSection(
            title: L10n.InternalMenu.tools,
            items: [InternalMenuCrashAppItemViewModel()]
        )

        sections = [
            infoSection,
            designKitSection,
            featureTogglesSection,
            toolsSection
        ]
    }
}

extension InternalMenuViewModel: DesignDemoResponder {
    func designDemo() {
        viewSubject.onNext(.designDemo)
    }
}
