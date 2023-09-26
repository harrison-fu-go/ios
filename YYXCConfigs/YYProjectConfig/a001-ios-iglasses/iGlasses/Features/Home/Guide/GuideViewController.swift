//
//  GuideNavigationController.swift
//  iGlasses
//
//  Created by fuhuayou on 2021/4/20.
//
import UIKit

class GuideNavigationController: UINavigationController {
    
    let viewModel: GuideViewModel

    init(viewModel: GuideViewModel, coder: NSCoder? = nil) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required convenience init(coder: NSCoder) {
        self.init(viewModel: GuideViewModel(), coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
