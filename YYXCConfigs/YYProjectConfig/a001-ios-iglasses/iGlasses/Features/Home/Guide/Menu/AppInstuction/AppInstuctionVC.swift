//
//  AppInstuctionVC.swift
//  iGlasses
//
//  Created by fuhuayou on 2021/4/26.
//

import UIKit

class AppInstuctionVC: UIViewController {

    @IBOutlet var naviBar: HoloeverHeaderTitleSearchView!
    @IBOutlet var tableView: UITableView! {
        didSet {
            tableView.separatorStyle = .none
        }
    }
    let cellIdentifier = "AppInstuctionVCCell"
    let datas = [["title":"连接及设置", "image":""],
                 ["title":"我的设置", "image":""]]
    override func viewDidLoad() {
        super.viewDidLoad()
        naviBar.setNavigationTitle(title: "Home APP指南")
        
        //register cell
        let cellNib = UINib(nibName:"TitleRightArrowTblCell", bundle: nil)
        self.tableView.register(cellNib, forCellReuseIdentifier: cellIdentifier)
    }

}


extension AppInstuctionVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    // swiftlint:disable force_cast force_unwrapping
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! TitleRightArrowTblCell
        cell.setTitle(title:datas[indexPath.row]["title"]!)
        return cell
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController?.pushViewController(MenuExampleVC(title: datas[indexPath.row]["title"]!), animated: true)
    }
}
