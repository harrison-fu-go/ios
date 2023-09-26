//
//  OperateGuideVC.swift
//  iGlasses
//
//  Created by fuhuayou on 2021/4/26.
//

import UIKit

class OperateGuideVC: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet var naviBar: HoloeverHeaderTitleSearchView!
    @IBOutlet var tableView: UITableView! {
        didSet {
            tableView.separatorStyle = .none
        }
    }
    let cellIdentifier = "OperateGuideVCCell"
    let datas = [["title":"智能音乐眼镜操作指南", "image":"OperationGuide_Default"],
                 ["title":"手机端Home APP指南", "image":"AppGuide_Default"]]
    override func viewDidLoad() {
        super.viewDidLoad()
        naviBar.setNavigationTitle(title: "操作导览")
        
        //register cell
        let cellNib = UINib(nibName:"IconTitleRightArrowTblCell", bundle: nil)
        self.tableView.register(cellNib, forCellReuseIdentifier: cellIdentifier)
    
        //add navigation pop gesture back.
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }

}


extension OperateGuideVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        2
    }
    
    // swiftlint:disable force_cast force_unwrapping
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! IconTitleRightArrowTblCell
        cell.setTitleAndImage(title:datas[indexPath.row]["title"]!, image:datas[indexPath.row]["image"]!)
        return cell
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            self.navigationController?.pushViewController(GlassesOperateInstructionVC(), animated: true)
        } else {
            self.navigationController?.pushViewController(AppInstuctionVC(), animated: true)
        }
    }
}
