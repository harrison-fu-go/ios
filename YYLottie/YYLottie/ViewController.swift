//
//  ViewController.swift
//  YYLottie
//
//  Created by HarrisonFu on 2023/11/15.
//

import UIKit
import Lottie
import SnapKit

class ViewController: UIViewController {
    var spatialLottieView: LottieAnimationView?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.spatialLottieView = .init(name: "Spatial_Audio_414p_Loop")
        guard let spatialLottieView = self.spatialLottieView else { return }
        spatialLottieView.contentMode = .scaleAspectFit
        spatialLottieView.loopMode = .loop
        spatialLottieView.backgroundBehavior = .pauseAndRestore
        spatialLottieView.logHierarchyKeypaths() //get the key path.
        
        let fillKeypath = AnimationKeypath(keypath: "Start Position..Color")
        let redValueProvider = ColorValueProvider(LottieColor(r: 0.0, g: 0.0, b: 0.0, a: 1.0))
        spatialLottieView.setValueProvider(redValueProvider, keypath: fillKeypath)
        
        self.view.addSubview(spatialLottieView)
        spatialLottieView.snp.makeConstraints({ make in
            make.center.equalToSuperview()
            make.width.height.equalTo(414)
        })
        spatialLottieView.play(completion: {_ in })
    }

}

