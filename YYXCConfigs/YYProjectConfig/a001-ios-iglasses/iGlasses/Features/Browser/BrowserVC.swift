//
//  BrowserVC.swift
//  iGlasses
//
//  Created by Matthew on 2021/4/28.
//

import UIKit
import WebKit

class BrowserVC: NiblessViewController {
    let viewModel: BrowserViewModel
    
    var webView: WKWebView!
    
    init(viewModel: BrowserViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func loadView() {
        let rootView = BrowserRootView(viewModel: self.viewModel)
        self.webView = rootView.webView
        self.view = rootView
        self.view.backgroundColor = .systemBackground
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
