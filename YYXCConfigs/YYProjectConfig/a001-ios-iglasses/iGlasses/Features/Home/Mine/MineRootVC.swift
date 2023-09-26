//
//  MineRootVC.swift
//  iGlasses
//
//  Created by fuhuayou on 2021/4/20.
//

import UIKit
import RxSwift
// swiftlint:disable prohibited_interface_builder
class MineRootVC: UIViewController, UIGestureRecognizerDelegate {
    
    let viewModel: MineRootViewModel
    let mineDependency: MineDependencyContainer
    
    init(viewModel: MineRootViewModel, mineDependency: MineDependencyContainer) {
        self.viewModel = viewModel
        self.mineDependency = mineDependency
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBOutlet weak var avatarModelImageView: UIImageView!
    @IBOutlet weak var avatarTitleLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var avatarContainerView: UIView! {
        didSet {
            avatarContainerView.layer.cornerRadius = 8.0
            avatarContainerView.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var tableView:UITableView!
    let cellIdentifier = "MineRootVCTblCell"
    // State
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //register table cell
        //register cell
        let cellNib = UINib(nibName:"MineItemCell", bundle: nil)
        self.tableView.register(cellNib, forCellReuseIdentifier: cellIdentifier)
        
        //set avatar & device name
        viewModel.deviceName.subscribe(onNext: {[weak self] in
            self?.avatarTitleLabel.text = $0
            self?.avatarImageView.isHighlighted = true
        }).disposed(by: disposeBag)
        viewModel.refreshDeviceName()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
//        //set version
//        let version = AppUpdateManager.currentVersion()[0]
//        self.versionLabel.text = "V" + version
//
//        //set hardware version.
//        self.viewModel.firmwareVersion.subscribe(onNext: {[weak self] in
//            self?.hardwareVersionLabel.text = $0
//        }).disposed(by: disposeBag)
//        self.viewModel.getFirmwareVersion()
    }
    
    @IBAction private func gotoModifyDeviceName(_ sender: Any) {
        let vc = mineDependency.makeModifyDeviceNameVC()
        vc.mineRootViewModel = viewModel
        show(viewController: vc)
    }
//
//    @IBAction private func gotoOperatingInstructions(_ sender: Any) {
//        let vc = mineDependency.makeOperatingInstructionsVC()
//        show(viewController: vc)
//    }
//
//    @IBAction private func gotoWearManage(_ sender: Any) {
//        let vc = mineDependency.makeWearManageVC()
//        show(viewController: vc)
//    }
//
    private func show(viewController: UIViewController) {
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func gotoPushMode() {
        let vc = mineDependency.makePushModeVC()
        show(viewController: vc)
    }

    
    func gotoHardwareUpdate() {
        let vc = mineDependency.makeHardwareUpdateVC()
        show(viewController: vc)
    }

    func gotoAppUpdate() {
        let vc = mineDependency.makeHomeAppUpdateVC()
        show(viewController: vc)
    }
}

//swiftlint:disable force_cast
extension MineRootVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! MineItemCell
        let itemModel = viewModel.items[indexPath.row]
        cell.setContent(type: itemModel["type"] as! MineItemType,
                        iIcon: itemModel["icon"] as! String,
                        iTitle: itemModel["title"] as! String)
        if indexPath.row == viewModel.items.count - 1 {
            cell.hideBaseLine()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 2 {
            gotoHardwareUpdate()
        } else if indexPath.row == 3 {
            gotoAppUpdate()
        }
    }
    
}
