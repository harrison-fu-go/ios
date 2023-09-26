//
//  LaunchVC.swift
//  iGlasses
//
//  Created by Matthew on 2021/4/15.
//

import Foundation

class LaunchVC: NiblessViewController {
    let viewModel: LaunchViewModel
    init(viewModel: LaunchViewModel) {
        self.viewModel = viewModel
        super.init()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

protocol LaunchViewModelFactory {
    func makeLaunchViewModel() -> LaunchViewModel
}
