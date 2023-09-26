//
//  BaseView.swift
//  iGlasses
//
//  Created by Matthew on 2021/4/13.
//

import UIKit

open class NiblessView: UIView {
    public override init(frame: CGRect) {
    super.init(frame: frame)
    }

    // swiftlint:disable no_hardcoded_strings
    @available(*, unavailable, message: "Loading this view from a nib is unsupported")
    public required init?(coder aDecoder: NSCoder) {
        fatalError("Loading this view from a nib is unsupported")
    }
    // swiftlint:enable no_hardcoded_strings
}
