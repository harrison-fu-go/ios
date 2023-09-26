//
//  PushManagerVC.swift
//  iGlasses
//
//  Created by zk-fuhuayou on 2021/8/10.
//

import UIKit

class PushManagerVC: UIViewController {
    
    let viewModel:PushManagerViewModel
    @IBOutlet var tableView:UITableView!
    @IBOutlet var naviBar: HoloeverHeaderTitleSearchView! {
        didSet {
            naviBar.titleLable.text = "推送管理"
            naviBar.enableSearch(isEnable: false)
        }
    }
    let cellIdentifier = "IconTextSwitchTableCell"

    init(viewModel: PushManagerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //register table cell
        let cellNib = UINib(nibName:"IconTextSwitchTableCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: cellIdentifier)
    }

}

//swiftlint:disable force_cast
extension PushManagerVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.pageContents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell:IconTextSwitchTableCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! IconTextSwitchTableCell
        tableCell.setContent(iIcon: viewModel.pageContents[indexPath.row]["icon"] as! UIImage,
                             iTitle: viewModel.pageContents[indexPath.row]["title"] as! String,
                             switchOn: viewModel.pageContents[indexPath.row]["switch"] as! Bool,
                             hideBaseLine: indexPath.row == viewModel.pageContents.count - 1)
        return tableCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRect(x: 0, y: 0, width:  UIScreen.screens[0].bounds.width, height: 88.0))
        let headerCV = TitleSwitchCustomView(frame: CGRect(x: 0, y: 16.0, width:UIScreen.screens[0].bounds.width, height: 56.0))
        headerCV.enableSwitch(enable: self.viewModel.allSwitch)
        header.addSubview(headerCV)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 88.0
    }

}
