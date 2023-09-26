//
//  GuideRootVC.swift
//  iGlasses
//
//  Created by fuhuayou on 2021/4/23.
//

import UIKit
import RxSwift
import MJRefresh
import SVProgressHUD

//swiftlint:disable force_cast
// swiftlint:disable force_unwrapping
class GuideRootVC: UIViewController {
    typealias BrowserFactory = (_ link: URL) -> BrowserVC
    
    @IBOutlet weak var naviBar: HoloeverHeaderView!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.backgroundColor = .clear
            tableView.separatorStyle = .none
            tableView.register(UINib(nibName: "GuideTopItemViewCell", bundle: nil), forCellReuseIdentifier: GuideTopItemViewCell.cellIdentifier)
            tableView.register(UINib(nibName: "GuideMiddleItemViewCell", bundle: nil), forCellReuseIdentifier: GuideMiddleItemViewCell.cellIdentifier)
            tableView.register(UINib(nibName: "GuideBottomItemViewCell", bundle: nil), forCellReuseIdentifier: GuideBottomItemViewCell.cellIdentifier)
            tableView.showsVerticalScrollIndicator = false
        }
    }
    
    private let viewModel: GuideRootViewModel
    private let browserFactory: BrowserFactory
    private let disposeBag = DisposeBag()
    private var newsGroup: [[GuideNews]] = []
    
    init(viewModel: GuideRootViewModel, browserFactory: @escaping BrowserFactory) {
        self.viewModel = viewModel
        self.browserFactory = browserFactory
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNaviBar()
        addRefreshHeader()
        addLoadMoreFooter()
        bindNavigateSubject()
        bindSectionSubject()
        bindErrorSubject()
        self.viewModel.refreshGuideList()
        naviBar.enableMenu(isEnable: false)
    }
    
    private func setupNaviBar() {
        naviBar.enableMenu(isEnable: true)
        //click menu.
        naviBar.menuBlock = {
            let nc:GuideNC = self.navigationController as! GuideNC
            nc.pushViewController(nc.dependencyContainer.makeOperateGuideVC(), animated: true)
        }
    }
    
    func addRefreshHeader() {
        self.tableView.mj_header = MJRefreshNormalHeader { [weak self] in
            self?.newsGroup = []
            self?.tableView.mj_footer?.resetNoMoreData()
            self?.viewModel.refreshGuideList()
        }
    }
    
    func addLoadMoreFooter() {
        self.tableView.mj_footer = MJRefreshAutoFooter { [weak self] in
            self?.viewModel.loadMoreGuideList()
        }
    }
    
    private func bindNavigateSubject() {
        let subject = self.viewModel.navigateSubject
        subject.subscribe(onNext: { [weak self] path in
            switch path {
            case .browser(let url):
                self?.navigateToBrowser(url)
            }
        }).disposed(by: disposeBag)
    }
    
    private func bindSectionSubject() {
        self.viewModel
            .newsSubject
            .subscribe(onNext: { [weak self] newsGroup in
                if !newsGroup.isEmpty {
                    self?.newsGroup += newsGroup
                    self?.tableView.reloadData()
                    self?.stopRefreshing()
                } else {
                    self?.tableView.mj_footer?.endRefreshingWithNoMoreData()
                }
            })
            .disposed(by: self.disposeBag)
        
    }
    
    private func bindErrorSubject() {
        self.viewModel
            .errorSubject
            .subscribe(onNext: { [weak self] error in
                self?.stopRefreshing()
                let isRefresing = self?.tableView.mj_header?.isRefreshing ?? false
                let isLoadingMore = self?.tableView.mj_footer?.isRefreshing ?? false
                if isRefresing || isLoadingMore {
                    SVProgressHUD.showError(withStatus: L10n.Guide.List.error)
                }
            })
            .disposed(by: self.disposeBag)
    }
    
    private func stopRefreshing() {
        if self.tableView.mj_header!.isRefreshing {
            self.tableView.mj_header!.endRefreshing()
        }
        if self.tableView.mj_footer!.isRefreshing {
            self.tableView.mj_footer!.endRefreshing()
        }
    }
    
    private func navigateToBrowser(_ url: URL) {
        let nc:GuideNC = self.navigationController as! GuideNC
        nc.pushViewController(browserFactory(url), animated: true)
    }
}

extension GuideRootVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.newsGroup.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.newsGroup[section].count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 0))
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let news = self.newsGroup[indexPath.section][indexPath.row]
        let cellType = news.type
        var cell: UITableViewCell!
        switch cellType {
        case 0:
            cell = tableView.dequeueReusableCell(withIdentifier: GuideTopItemViewCell.cellIdentifier)
            (cell as? GuideTopItemViewCell)?.updateViewData(news)
        case 1:
            if indexPath.row == self.newsGroup[indexPath.section].count - 1 {
                cell = tableView.dequeueReusableCell(withIdentifier: GuideBottomItemViewCell.cellIdentifier)
                (cell as? GuideBottomItemViewCell)?.updateViewData(news)
            } else {
                cell = tableView.dequeueReusableCell(withIdentifier: GuideMiddleItemViewCell.cellIdentifier)
                (cell as? GuideMiddleItemViewCell)?.updateViewData(news)
            }
        default:
            cell = UITableViewCell()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let topCell = cell as? GuideTopItemViewCell
        let middleCell = cell as? GuideMiddleItemViewCell
        let bottomCell = cell as? GuideBottomItemViewCell
        if let cell = topCell {
            cell.setTopCorner(bounds: cell.bounds)
        }
        if let cell = middleCell {
            cell.addShadow(bounds: cell.bounds)
        }
        if let cell = bottomCell {
            cell.setBottomCorner(bounds: cell.bounds)
        }
    }
    
}

extension GuideRootVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.navigateToBrowser(url: self.newsGroup[indexPath.section][indexPath.row].link)
    }
    
}
