//
//  WearManageVC.swift
//  iGlasses
//
//  Created by fuhuayou on 2021/4/21.
//

import UIKit
// swiftlint:disable force_unwrapping
class WearManageVC: UIViewController {
    let cellIdentifier = "WearManageVCTblCell"
    let titles = [["title": "低电量语音提醒", "image":"battery.25"], ["title": "来电播报", "image":"phone.bubble.left.fill"]]
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.backgroundColor = .clear
            tableView.separatorStyle = .none
        }
    }
    @IBOutlet var naviBar: HoloeverHeaderTitleSearchView! {
        didSet {
            naviBar.enableSearch(isEnable: false)
            naviBar.titleLable.text = "佩戴监测"
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // register nib.
        let nib = UINib(nibName:"WearManageTblCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: cellIdentifier)
    }
}

extension WearManageVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? WearManageTblCell
        cell?.titleLable?.text = titles[indexPath.row]["title"]!
        if indexPath.row == 1 {
            cell?.bottomLine.isHidden = true
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
}
