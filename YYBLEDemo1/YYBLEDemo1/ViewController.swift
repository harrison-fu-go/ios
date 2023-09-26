//
//  ViewController.swift
//  YYBLEDemo1
//
//  Created by yy.Fu on 2021/3/30.
//

import UIKit
import RxSwift
import RxCocoa
import CoreBluetooth
import SnapKit
class ViewController: UIViewController, ConstraintRelatableTarget, BLECenterProtocol {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var scanBtn: UIButton!
    @IBOutlet weak var topNaviItem: UINavigationItem!
    
    var iBleCenter: BLECenter?
    var otaMgr: BLEOTAMgr?
    
    // rxswift
    let disposeBag = DisposeBag()
    let vm = ViewControllerVM()
    
    let table = UITableView()
    var scanedDevices:[BLEDevice]?
    
    var timer: ZKTimer?
    
    var tasks:[String: Any] = [:]
    
    
    let testView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scanedDevices = []
        self.iBleCenter = BLECenter();
        
//        self.iBleCenter?.scan(true)

        scanBtn.rx.tap.subscribe(onNext: {[weak self] in
            let sender = self!.scanBtn!;
            sender.isSelected = !sender.isSelected;
           // self?.iBleCenter?.scan((self?.scanBtn.isSelected)!, nil, 20, nil)//["6006"] ["180d"]["9BC1F0DC-F4CB-4159-BD38-7375CD0DD545"], ["180A", "2600"]
            self?.iBleCenter?.scan((self?.scanBtn.isSelected)!, nil, 20, nil)//["9BC1F0DC-F4CB-4159-BD38-7375CD0DD545"]
        }).disposed(by: disposeBag)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.iBleCenter?.delegates.add(delegate: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.iBleCenter?.delegates.remove(delegate: self)
    }
    
    func onConnectStateDidUpdate(state: BLEConnState) {
        DispatchQueue.main.async {
            if state == .connected {
                let ivc: DeviceManagerVC? = self.storyboard?.instantiateViewController(identifier:"DeviceManagerVC") as? DeviceManagerVC
                ivc?.bleCenter = self.iBleCenter
                self.navigationController?.pushViewController(ivc!, animated: true);
            }
        }
    }
    
    func onScanDevicesListUpdate(devices: [BLEDevice]) {
        DispatchQueue.main.async {
            self.scanedDevices = devices
            self.tableView.reloadData()
        }
    }
    
    
    @IBAction func connect (_ sender : UIButton) {
        if sender.tag == 0 {
            self.iBleCenter?.connectFromConnectedList(serviceUUID: "6006", callback: { mess in //"FFE0"
                print("========connectFromConnectedList : ", mess)
            })
        } else {
            self.iBleCenter?.reconnect(callback: { mess in
                print("========reconnect : ", mess)
            })
        }
    }
    

    @IBAction func ota (_ sender : UIButton) {
//        let path = Bundle.main.path(forResource: "ZeGear_v1.9_191225", ofType: "bin")
//        otaMgr = BLEOTAMgr(iBleCenter, path);
//        otaMgr?.resumeStream()
//        BLETasksCenter().getTask()
    }
    
    @IBAction func scan(_ sender : UIButton) {
//        self.iBleCenter?.scan(true, nil, 20, ["6606", "6666", "FFE0"], { [self](devices) in
//            self.scanedDevices = devices
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//            }
//        })
    }
}

extension ViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.scanedDevices?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "BLECellIdentifier"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier);
        if cell == nil {
            cell = UITableViewCell.init(style:UITableViewCell.CellStyle.subtitle, reuseIdentifier: cellIdentifier);
        }
        cell?.textLabel?.text = self.scanedDevices?[indexPath.row].name
        cell?.detailTextLabel?.text = self.scanedDevices?[indexPath.row].uuid
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let device = scanedDevices?[indexPath.row]
        self.iBleCenter?.connectDevice(device: device!, callback: { (result) in
            print("========== result: ", result)
        })
    }
}

