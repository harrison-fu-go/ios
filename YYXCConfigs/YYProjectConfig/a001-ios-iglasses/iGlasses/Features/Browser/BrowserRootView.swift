//
//  BrowserRootView.swift
//  iGlasses
//
//  Created by Matthew on 2021/4/28.
//

import UIKit
import WebKit

class BrowserRootView: NiblessView {
    
    let headerView = configure(HoloeverHeaderTitleSearchView(frame: .zero)) { it in
        it.enableSearch(isEnable: false)
    }
    
    let webView: WKWebView = configure(WKWebView(frame: .zero, configuration: {
        let config = WKWebViewConfiguration()
        config.preferences = WKPreferences()
        config.preferences.javaScriptEnabled = true
        // 在iOS上默认为NO，表示不能自动通过窗口打开
        config.preferences.javaScriptCanOpenWindowsAutomatically = false
        // web内容处理池
        config.processPool = WKProcessPool()
        config.userContentController = WKUserContentController()
        return config
    }())) { _ in

    }
    
    private let viewModel: BrowserViewModel
    
    init(viewModel: BrowserViewModel, frame: CGRect = .zero) {
        self.viewModel = viewModel
        super.init(frame: frame)
    }
    
    override func didMoveToWindow() {
        constructViewHierarchy()
        activateConstraints()
        loadURL()
        
        headerView.setNavigationTitle(title: "导览说明", false)
    }
    
    func constructViewHierarchy() {
        addSubview(headerView)
        addSubview(webView)
    }

    func activateConstraints() {
        activateConstraintsHeaderView()
        activateConstraintsWebView()
    }

    func activateConstraintsHeaderView() {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        let top = headerView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor)
        let leading = headerView.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        let trailing = headerView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        let height = headerView.heightAnchor.constraint(equalToConstant: 44)

        NSLayoutConstraint.activate([top, leading, trailing, height])
    }
    
    func activateConstraintsWebView() {
        webView.translatesAutoresizingMaskIntoConstraints = false
        let top = webView.topAnchor.constraint(equalTo: self.headerView.bottomAnchor)
        let leading = webView.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        let trailing = webView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        let bottom = webView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)

        NSLayoutConstraint.activate([top, leading, trailing, bottom])
    }
    
    private func loadURL() {
        let request = URLRequest(url: self.viewModel.link)
        self.webView.load(request)
    }
    
}
