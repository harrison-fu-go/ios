//
//  UIViewControllerExtension.swift
//  iGlasses
//
//  Created by Matthew on 2021/4/15.
//

import UIKit

// swiftlint:disable extension_access_modifier
extension UIViewController {
    public func addFullScreen(childViewController child: UIViewController) {
      guard child.parent == nil else { return }

      addChild(child)
      view.addSubview(child.view)
      child.view.translatesAutoresizingMaskIntoConstraints = false

      NSLayoutConstraint.activate([
        view.leadingAnchor.constraint(equalTo: child.view.leadingAnchor),
        view.trailingAnchor.constraint(equalTo: child.view.trailingAnchor),
        view.topAnchor.constraint(equalTo: child.view.topAnchor),
        view.bottomAnchor.constraint(equalTo: child.view.bottomAnchor)
      ].compactMap { $0 })

      child.didMove(toParent: self)
    }

    public func remove(childViewController child: UIViewController) {
      guard child.parent != nil else { return }

      child.willMove(toParent: nil)
      child.view.removeFromSuperview()
      child.removeFromParent()
    }
}
