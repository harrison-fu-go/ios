//
//  ConnectionRootVC.swift
//  iGlasses
//
//  Created by fuhuayou on 2021/4/20.
//

import UIKit
import Lottie
import RxSwift
class ConnectionRootVC: UIViewController, UIGestureRecognizerDelegate {
    @IBOutlet var headerView: HoloeverHeaderView! {
        didSet {
            headerView.enableMenu(isEnable: true)
        }
    }
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var bleSwith: CustomSwitch?
    
    @IBOutlet var bigGlassesImageView: UIImageView?

    @IBOutlet var bleConStateLable: UILabel?
    @IBOutlet var batteryStateLable: UILabel?
    @IBOutlet var bleConStateImageView: UIImageView?
    @IBOutlet var batteryConStateImageView: UIImageView?
    @IBOutlet var batteryBaseView: UIView?
    @IBOutlet weak var batteryWidth: NSLayoutConstraint!
    @IBOutlet weak var batteryValueView: UIView!
    //connect animation
    private var animationView: AnimationView = AnimationView(animation: Animation.named("connectBLEAnimation"))
    let viewModel: ConnectionRootViewModel
    let disposeBag = DisposeBag()
    init(viewModel: ConnectionRootViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required convenience init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        //header
        headerView.menuBlock = {
            let viewModel = PushManagerViewModel()
            let vc = PushManagerVC(viewModel: viewModel)
            self.navigationController?.pushViewController(vc, animated: true)
        }

        addConnectAnimation()
        self.viewModel.connectState.subscribe(onNext: { state in
            print("============= onNext: ", state.rawValue)
            switch state {
            case .searching:
                self.onConnecting()
            case .connecting:
                break
            case .connected:
                self.onConnected()
            case .disconnected:
                self.onDisconnected()
            default:
                break
            }
        }).disposed(by: disposeBag)
        bleSwith?.addStateBlock(handle: { state in
            self.viewModel.connect(isEnable: state)
        })
        
        self.viewModel.firstTimeConnect()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        usernameLabel.text = UserDefaults.standard.string(forKey: "A001DeviceName") ?? USER_BASE.defaultName
        usernameLabel.text = BLEManager.ble().connectedDevice?.name ?? ""
    }
    
    func addConnectAnimation() {
        self.view.addSubview(animationView)
        animationView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(headerView.snp_bottomMargin)
            make.height.equalTo(368)
        }
        self.animationView.isHidden = true
        self.animationView.loopMode = .loop
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !self.animationView.isHidden && self.animationView.isAnimationPlaying == false {
            self.animationView.play()
        }
    }
    
    func onConnecting(isCycle: Bool = false) {
        self.animationView.isHidden = false
        self.animationView.play()
        self.bigGlassesImageView?.isHidden = true
        self.bigGlassesImageView?.isHighlighted = true
        self.enableConnectedState(enable: false)
        self.setBattery(val: 0)
        self.bleSwith?.enableSwith(isEnable: true)
    }
    
    //swiftlint:disable legacy_random
    func onConnected() {
        animationView.stop()
        self.animationView.isHidden = true
        self.bleSwith?.enableSwith(isEnable: true)
        self.bigGlassesImageView?.isHidden = false
        self.bigGlassesImageView?.isHighlighted = true
        self.setBattery(val: Float(Int( arc4random() % 100 ) + 1))
        self.enableConnectedState(enable: true)
        usernameLabel.text = BLEManager.ble().connectedDevice?.name ?? ""
    }
    
    func onDisconnected() {
        animationView.stop()
        self.animationView.isHidden = true
        self.bleSwith?.enableSwith(isEnable: false)
        self.bigGlassesImageView?.isHidden = false
        self.bigGlassesImageView?.isHighlighted = false
        self.setBattery(val: 0)
        self.enableConnectedState(enable: false)
        usernameLabel.text = BLEManager.ble().connectedDevice?.name ?? ""
    }
    
    func enableConnectedState(enable:Bool) {
        self.bleConStateImageView?.isHighlighted = enable
        self.batteryConStateImageView?.isHighlighted = enable
        self.bleConStateLable?.text = enable ? "已连接": "未连接"
        self.bleConStateLable?.textColor = enable ? UIColor(hex: 0x666666) : UIColor(hex: 0xcccccc)
        if !enable {
            self.batteryStateLable?.text = "未连接"
        }
        self.batteryStateLable?.textColor = enable ? UIColor(hex: 0x666666) : UIColor(hex: 0xcccccc)
    }
    
    func setBattery(val: Float) {
        var color = 0x34CF98 //green  //yellow F6AB3E
        if val <= 20 {
            color = 0xCF4934 //red
        }
        self.batteryValueView.backgroundColor = UIColor(hex: color)
        self.batteryWidth.constant = CGFloat((val / 100.0) * 13.0)
        self.batteryStateLable?.text = "\(Int(val))%"
    }
}
