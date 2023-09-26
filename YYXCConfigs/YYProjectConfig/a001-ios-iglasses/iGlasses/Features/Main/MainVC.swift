//
//  MainVC.swift
//  iGlasses
//
//  Created by Matthew on 2021/4/14.
//
import UIKit
import RxSwift

class MainVC: NiblessViewController {
    let viewModel: MainViewModel

    typealias LaunchViewControllerFactory = () -> LaunchVC
    typealias HomeViewControllerFactory = () -> HomeVC
    typealias SplashViewControllerFactory = () -> SplashVC

    // View Factory
    let launchViewControllerFactory: LaunchViewControllerFactory
    let homeViewControllerFactory: HomeViewControllerFactory
    let splashViewControllerFactory: SplashViewControllerFactory

    // Views
    var launchViewController: LaunchVC?

    // State
    let disposeBag = DisposeBag()

    init(viewModel: MainViewModel,
         launchViewControllerFactory: @escaping LaunchViewControllerFactory,
         homeViewControllerFactory: @escaping HomeViewControllerFactory,
         splashViewControllerFactory: @escaping SplashViewControllerFactory) {
        self.viewModel = viewModel
        self.launchViewControllerFactory = launchViewControllerFactory
        self.homeViewControllerFactory = homeViewControllerFactory
        self.splashViewControllerFactory = splashViewControllerFactory
        super.init()
    }

    override func loadView() {
        self.view = MainRootView(viewModel: self.viewModel)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        observedViewModel()
        presentSplash()
    }
    private func observedViewModel() {
        viewModel.viewStatus.subscribe(onNext: {[weak self] in
            switch $0 {
            case .guide:
                self?.presentGuide()
            case .home:
                self?.presentHome()
            }
        }).disposed(by: disposeBag)
    }

    private func presentSplash() {
        addFullScreen(childViewController: self.splashViewControllerFactory())
    }

    private func presentGuide() {
    }

    private func presentHome() {
        addFullScreen(childViewController: self.homeViewControllerFactory())
    }
}
