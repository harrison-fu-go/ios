//
//  SplashVC.swift
//  iGlasses
//
//  Created by fuhuayou on 2021/4/19.
//
import UIKit
import Lottie
import SnapKit

class SplashVC: UIViewController {
    
    private var animationView: AnimationView = AnimationView(animation: Animation.named("SplashAnimation"))
    private let viewModel: SplashViewModel
    
    init(viewModel: SplashViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        constructViewHierarchy()
        activateConstraints()
        playAnimation()
    }
    
    func constructViewHierarchy() {
        view.addSubview(animationView)
    }

    func activateConstraints() {
        activateConstraintsAnimationView()
    }

    func activateConstraintsAnimationView() {
        animationView.snp.makeConstraints { make in
            make.top.equalTo(self.view.snp.top)
            make.leading.equalTo(self.view.snp.leading)
            make.trailing.equalTo(self.view.snp.trailing)
            make.bottom.equalTo(self.view.snp.bottom)
        }
    }
    
    func playAnimation() {
//        animationView.play { finished in
//            if finished {
//                self.viewModel.gotoHome()
//            }
//        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.viewModel.gotoHome()
    }
}

protocol SplashViewModelFactory {
    func makeSplashViewModel() -> SplashViewModel
}
