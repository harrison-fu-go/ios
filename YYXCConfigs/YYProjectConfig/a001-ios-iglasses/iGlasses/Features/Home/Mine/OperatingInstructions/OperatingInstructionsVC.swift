//
//  OperatingInstructionsVC.swift
//  iGlasses
//
//  Created by fuhuayou on 2021/4/20.
//
// swiftlint:disable force_cast
// swiftlint:disable prohibited_interface_builder
import UIKit

class OperatingInstructionsVC: UIViewController {
    @IBOutlet var naviBar: HoloeverHeaderTitleSearchView!
    let headers = ["左侧触控板设置", "右侧侧触控板设置", "右侧实体按键"]
    let cellTitles = [[["向前滑动", "音量+"], ["向后滑动", "音量－"], ["双击", "播放/暂停"], ["长按2s", "歌词显示/隐藏"]],
                      [["前后滑动", "（按键状态）切换焦点"], ["前后滑动", "（提示界面）展开/关闭"], ["前后滑动", "（阅读界面）滑动滚动条"], ["长按2s", "取消/退出"]],
                      [["长按3s", "电源开机/关机"], ["双击", "蓝牙配对"], ["单击", "熄屏/亮屏"]]]
    let cellIdentifier = "OperatingInstructionsTBCell"
    let headerIdentifier = "OperatingInstructionsTabSectionHeader"
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            self.tableView.separatorStyle = .none
            self.tableView.backgroundColor = .clear
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set navi bar
        self.naviBar.titleLable.text = "操作设置说明"
        self.naviBar.enableSearch(isEnable: false)

        // register cell
        tableView.separatorStyle = .none
        let cellNib = UINib(nibName:"OperatingInstructionTblCell", bundle: nil)
        self.tableView.register(cellNib, forCellReuseIdentifier: cellIdentifier)
        
        // register header.
        let headerNib = UINib(nibName:"OperatingInstructionsTabSectionHeader", bundle: nil)
        self.tableView.register(headerNib, forHeaderFooterViewReuseIdentifier: headerIdentifier)
    }
}

extension OperatingInstructionsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellTitles[section].count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return headers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! OperatingInstructionTblCell
        cell.leftLabel.text = cellTitles[indexPath.section][indexPath.row][0]
        cell.rightLabel.text = cellTitles[indexPath.section][indexPath.row][1]
        if ((indexPath.section == 0 || indexPath.section == 1) && indexPath.row == 3) ||
            (indexPath.section == 2 && indexPath.row == 2) {
            cell.bottomLine.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerIdentifier) as! OperatingInstructionsTabSectionHeader
        header.titelLabel.text = headers[section]
        header.backgroundColor = .clear
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}
