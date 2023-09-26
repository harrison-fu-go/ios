//
//  ConnectionNC.swift
//  iGlasses
//
//  Created by fuhuayou on 2021/4/20.
//

import UIKit

class ConnectionNC: UINavigationController {
    let dependencyContainer: ConnectionDependencyContainer
    init(dependency: ConnectionDependencyContainer) {
        self.dependencyContainer = dependency
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required convenience init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // hide navigation bar.
        self.setNavigationBarHidden(true, animated: false)
        
        // set sub views contollers.
        setViewControllers([dependencyContainer.makeConnectionRootVC()], animated: true)
    }
}

extension ConnectionNC {
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        viewController.hidesBottomBarWhenPushed = true
        super.pushViewController(viewController, animated: true)
        viewController.hidesBottomBarWhenPushed = false
    }

    override func popViewController(animated: Bool) -> UIViewController? {
        if self.viewControllers.count <= 2 {
            let controller:UIViewController = self.viewControllers[0]
            controller.hidesBottomBarWhenPushed = false
        } else {
            let count = self.viewControllers.count - 2
            let controller = self.viewControllers[count]
            controller.hidesBottomBarWhenPushed = true
        }
        return super.popViewController(animated: true)
    }
}
