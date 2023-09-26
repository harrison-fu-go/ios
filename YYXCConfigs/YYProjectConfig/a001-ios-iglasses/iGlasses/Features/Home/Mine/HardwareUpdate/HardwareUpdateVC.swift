//
//  HardwareUpdateVC.swift
//  iGlasses
//
//  Created by fuhuayou on 2021/4/21.
//

import UIKit
import RxCocoa
import RxSwift

class HardwareUpdateVC: UIViewController {
    
    enum OpCase {
        case latest
        case haveNewVersion
        case downloading
        case updating
    }
    
    let viewModel:HardwearUpdateViewModel
    @IBOutlet var naviBar: HoloeverHeaderTitleSearchView! {
        didSet {
            naviBar.titleLable.text = "眼镜端固件更新"
            naviBar.enableSearch(isEnable: false)
        }
    }
    @IBOutlet weak var currentVersionLabel:UILabel!
    @IBOutlet weak var latestVersionMessLabel:UILabel!
    
    @IBOutlet weak var firmwareLable: UILabel!
    @IBOutlet weak var downloadBtn: UIButton! {
        didSet {
            self.downloadBtn.layer.cornerRadius = 24
            self.downloadBtn.clipsToBounds = true
            let layer = CAGradientLayer()
            layer.frame = self.downloadBtn.bounds
            layer.colors = [UIColor(hex: 0x178ACA).cgColor, UIColor(hex: 0x0A66C3).cgColor]
            layer.startPoint = CGPoint(x: 0, y: 0)
            layer.endPoint = CGPoint(x: 1, y: 0)
            self.downloadBtn.layer.addSublayer(layer)
        }
    }
    
    
    @IBOutlet weak var deviceImageView: UIImageView! {
        didSet {
            self.deviceImageView.layer.cornerRadius = 15
            self.deviceImageView.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var downloadIndecateContainer: UIView!
    @IBOutlet weak var downloadProgress: UIProgressView!
    @IBOutlet weak var downloadProgressLable: UILabel!
    @IBOutlet weak var progressTitle: UILabel!
    
    @IBOutlet weak var progressBar: CustomGradualProgressBar! {
        didSet {
            progressBar.setColors(graduals: [UIColor(hex: 0x178ACA), UIColor(hex: 0x0A66C3)],
                                  bgColor: UIColor(hex: 0xD7E6F1))
        }
    }
    
    private let disposeBag = DisposeBag()
    
    init(viewModel: HardwearUpdateViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func downloadForUpdate(_ sender: UIButton) {
        self.disableDownloadBtn(sender: sender)
        print("========= download ===== ")
        self.setOperateCase(op: .downloading)
        self.viewModel.downloadHandle.subscribe(onNext: { handle in
            if handle.state == .onGoing {
                self.setUpdateProgressValue(value: Float(handle.progress))
            } else if handle.state == .complete {
                print("========= updating ===== ")
                self.onFirmwareUpdate()
                
            } else {
                AlertViewPermission.popUp(message: ["title":"下载失败", "message":"好的"]) {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }).disposed(by: self.disposeBag)
        self.viewModel.downloadFirmware()
    }
    
    func disableDownloadBtn(sender: UIButton) {
        sender.isEnabled = false
        sender.alpha = 0.3
    }
    
    func onFirmwareUpdate() {
        self.setOperateCase(op: .updating)
        self.viewModel.updateHandle.subscribe(onNext: { handle in
            if handle.state == .onGoing {
                print("============handle.progress=========", handle.progress)
                self.setUpdateProgressValue(value: Float(handle.progress))
            } else if handle.state == .complete {
                DispatchQueue.main.async {
                    AlertViewPermission.popUp(message: ["title":"更新成功", "message":"好的"]) {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
                
            } else {
                DispatchQueue.main.async {
                    AlertViewPermission.popUp(message: ["title":"更新失败", "message":"好的"]) {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }).disposed(by: self.disposeBag)
        self.viewModel.udpateFirmware()
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.global().async {
            //1. set current version.
            self.viewModel.currentVersion.subscribe(onNext: {[weak self] version in
                DispatchQueue.main.async {
                    self?.currentVersionLabel.text = version
                }
            }).disposed(by: self.disposeBag)
            self.viewModel.getCurrentVersion()
            
            //2. set default state
            self.setOperateCase(op: .latest)
            
            //3. check
            self.viewModel.newVersion.subscribe(onNext: {[weak self] version in
                print("============ version=====", version)
                let isHaveUdpate = (version["haveUpdate"] as? Bool) ?? false
                let newVersion = (version["version"] as? String) ?? ""
                if isHaveUdpate {
                    self?.setOperateCase(op: .haveNewVersion, newVer: newVersion)
                } else {
                    self?.setOperateCase(op: .latest)
                }
            }).disposed(by: self.disposeBag)
            self.viewModel.checkNewVersion()
        }
    }
    
    func setOperateCase(op: OpCase, newVer: String? = nil) {
        DispatchQueue.main.async {
            switch op {
            case .latest:
                self.downloadBtn.isHidden = true
                self.progressBar.isHidden = true
                self.downloadProgressLable.isHidden = true
                self.latestVersionMessLabel.isHidden = false
            case .haveNewVersion:
                self.downloadBtn.isHidden = false
                self.progressBar.isHidden = true
                self.downloadProgressLable.isHidden = true
                self.latestVersionMessLabel.isHidden = false
                self.latestVersionMessLabel.text = "检测到更新版本: v" + (newVer ?? "")
            case .downloading:
                self.downloadBtn.isHidden = false
                self.progressBar.isHidden = false
                self.downloadProgressLable.isHidden = false
                self.latestVersionMessLabel.isHidden = false
                self.setUpdateProgressValue(value: 0)
                self.downloadBtn.setTitle("正在下载中", for: .normal)
                self.downloadBtn.setTitle("正在下载中", for: .highlighted)
            case .updating:
                self.downloadBtn.isHidden = false
                self.progressBar.isHidden = false
                self.downloadProgressLable.isHidden = false
                self.latestVersionMessLabel.isHidden = false
                self.setUpdateProgressValue(value: 0)
                self.downloadBtn.setTitle("正在更新中", for: .normal)
                self.downloadBtn.setTitle("正在更新中", for: .highlighted)
            }
        }
    }
    
    func setUpdateProgressValue(value: Float) {
        DispatchQueue.main.async {
            self.progressBar.setProgressValue(val: value * 100.0, 0.2)
            self.downloadProgressLable.text = "\(Double(value * 100.0).roundTo(bits: 1))%"
        }
    }
}
