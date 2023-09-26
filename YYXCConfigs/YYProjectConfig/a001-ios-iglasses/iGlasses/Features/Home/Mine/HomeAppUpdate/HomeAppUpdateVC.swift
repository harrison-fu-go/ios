//
//  HomeAppUpdateVC.swift
//  iGlasses
//
//  Created by fuhuayou on 2021/4/26.
//

import UIKit
import RxSwift

class HomeAppUpdateVC: UIViewController {
    
    let viewModel:HomeAppUpdateViewModel
    private let dispose = DisposeBag()
    
    init(viewModel: HomeAppUpdateViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    //swiftlint:disable unavailable_function
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBOutlet var naviBar: HoloeverHeaderTitleSearchView! {
        didSet {
            naviBar.titleLable.text = "手机端软件更新"
            naviBar.enableSearch(isEnable: false)
        }
    }
    
    @IBOutlet var updateButton: UIButton! {
        didSet {
            self.updateButton.layer.cornerRadius = 24
            self.updateButton.clipsToBounds = true
            let layer = CAGradientLayer()
            layer.frame = self.updateButton.bounds
            layer.colors = [UIColor(hex: 0x178ACA).cgColor, UIColor(hex: 0x0A66C3).cgColor]
            layer.startPoint = CGPoint(x: 0, y: 0)
            layer.endPoint = CGPoint(x: 1, y: 0)
            self.updateButton.layer.addSublayer(layer)
        }
    }
    @IBOutlet var currentVersionLabel: UILabel!
    @IBOutlet var checkedVersionLabel: UILabel!
    
    
    @IBAction func gotoUpdate(_ sender: UIButton) {
        self.viewModel.skipToDownloadApp()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observeAppVersionUpdate()
    }

    //swiftlint:disable force_unwrapping
    func observeAppVersionUpdate() {
        self.viewModel.appVersionSubject.subscribe(onNext: {[weak self] in
            self?.currentVersionLabel.text = "HOLOEVER" + $0["currentVersion"]!
            let haveUpdate = Int($0["HaveUpdate"]!) == 1
            if haveUpdate {
                self?.updateButton.isHidden = false
                self?.checkedVersionLabel.text = "检测到更新版本: " + $0["newVersion"]!
            } else {
                self?.checkedVersionLabel.text = "当前版本最新"
            }
        }).disposed(by: dispose)
        self.viewModel.checkAppVersion()
    }
}
