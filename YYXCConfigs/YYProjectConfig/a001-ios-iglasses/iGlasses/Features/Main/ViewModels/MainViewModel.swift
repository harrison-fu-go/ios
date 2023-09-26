//
//  MainViewModel.swift
//  iGlasses
//
//  Created by Matthew on 2021/4/14.
//

import Foundation
import RxSwift

enum MainViewModeType {
    case guide
    case home
}

class MainViewModel {
    var viewStatus: Observable<MainViewModeType> {
      return viewSubject.asObservable()
    }

    private let viewSubject = PublishSubject<MainViewModeType>()

    @objc
    func showGuide() {
        navigateToGuide()
    }
}

extension MainViewModel: NavigateToHomeProtocol, NavigateToGuideProtocol {
    func navigateToHome() {
        viewSubject.onNext(.home)
    }

    func navigateToGuide() {
        viewSubject.onNext(.guide)
    }
}
