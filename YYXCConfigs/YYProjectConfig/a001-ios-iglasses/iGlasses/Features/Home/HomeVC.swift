//
//  HomeVC.swift
//  iGlasses
//
//  Created by Matthew on 2021/4/15.
//

import UIKit

class HomeVC: NiblessViewController {
    let viewModel: HomeViewModel
    var tabBar: UITabBarController!

    let guideVC: GuideNC
    let connectionVC: ConnectionNC
    let mineVC: MineNC

    init(viewModel: HomeViewModel,
         guide: GuideNC,
         connection: ConnectionNC,
         mine: MineNC) {
        self.viewModel = viewModel
        self.guideVC = guide
        self.connectionVC = connection
        self.mineVC = mine
        super.init()
    }

    override func loadView() {
        self.view = HomeRootView()
        self.tabBar = UITabBarController()
        self.guideVC.tabBarItem = UITabBarItem(title:"导览",
                                               image:Asset.TabBarItems.guideUnselected.image,
                                               selectedImage: Asset.TabBarItems.guideSelected.image)
        self.connectionVC.tabBarItem = UITabBarItem(title:"连接",
                                                    image:Asset.TabBarItems.connectUnselected.image,
                                                    selectedImage: Asset.TabBarItems.connectSelected.image)
        self.mineVC.tabBarItem = UITabBarItem(title:"我的",
                                              image:Asset.TabBarItems.myUnselected.image,
                                              selectedImage: Asset.TabBarItems.mySelected.image)
        self.tabBar.setViewControllers([self.guideVC, self.connectionVC, self.mineVC], animated: true)
        self.tabBar.selectedIndex = 1
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .orange

        addFullScreen(childViewController: self.tabBar)
        
        self.viewModel.loadAppRemoteConfig()
        self.viewModel.checkAppUpdate()
        
        
    }
}
