//
//  MainRootView.swift
//  iGlasses
//
//  Created by Matthew on 2021/4/14.
//

import UIKit

class MainRootView: NiblessView {
//    let homeLabel: UILabel = configure(UILabel(frame: .zero)) {
//        $0.font = UIFont.designKit.display1
//        $0.textColor = UIColor.designKit.primaryText
//        $0.text = L10n.home
//    }
//
//    let showGuideButton: UIButton = configure(UIButton(type: .system)) {
//        $0.setTitle("show guide", for: .normal)
//    }

    let viewModel: MainViewModel

    init(viewModel: MainViewModel, frame: CGRect = .zero) {
      self.viewModel = viewModel
      super.init(frame: frame)
    }

//    override func didMoveToWindow() {
//        constructViewHierarchy()
//        activateConstraints()
//
//        self.showGuideButton.addTarget(self.viewModel, action: #selector(MainViewModel.showGuide), for: .touchUpInside)
//    }
//
//    func constructViewHierarchy() {
//        addSubview(homeLabel)
//        addSubview(showGuideButton)
//    }
//
//    func activateConstraints() {
//        activateConstraintsHomeLabel()
//        activeConstraintsShowGuideButton()
//    }
//
//    func activateConstraintsHomeLabel() {
//        homeLabel.translatesAutoresizingMaskIntoConstraints = false
//        let top = homeLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 30)
//        let centerX = homeLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
//
//        NSLayoutConstraint.activate([top, centerX])
//    }
//
//    func activeConstraintsShowGuideButton() {
//        showGuideButton.translatesAutoresizingMaskIntoConstraints = false
//        let centerX = showGuideButton.centerXAnchor.constraint(equalTo: self.centerXAnchor)
//        let centerY = showGuideButton.centerYAnchor.constraint(equalTo: self.centerYAnchor)
//
//        NSLayoutConstraint.activate([centerY, centerX])
//    }
}
