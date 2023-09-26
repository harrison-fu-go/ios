//
//  File.swift
//  iGlasses
//
//  Created by Matthew on 2021/4/13.
//

import UIKit

protocol BaseViewControllerProtocol {
}

class NibViewController: UIViewController, BaseViewControllerProtocol {
}

class NiblessViewController: UIViewController, BaseViewControllerProtocol {
    /// - Methods
    init() {
      super.init(nibName: nil, bundle: nil)
    }

    // swiftlint:disable no_hardcoded_strings
    @available(*, unavailable, message: "Loading this view controller from a nib is unsupported")
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
      super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    // swiftlint:enable no_hardcoded_strings

    // swiftlint:disable no_hardcoded_strings
    @available(*, unavailable, message: "Loading this view controller from a nib is unsupported")
    required init(coder aDecoder: NSCoder) {
      fatalError("Loading this view controller from a nib is unsupported")
    }
    // swiftlint:enable no_hardcoded_strings
}
