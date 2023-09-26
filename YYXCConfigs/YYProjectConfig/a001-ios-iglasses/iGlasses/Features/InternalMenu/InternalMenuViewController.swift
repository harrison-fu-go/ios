//
//  InternalMenuViewController.swift
//  iGlasses
//
//  Created by Matthew on 2021/4/13.
//

import UIKit
import RxSwift

class InternalMenuViewController: NiblessViewController {
    let viewModel = InternalMenuViewModel()
    let disposeBag = DisposeBag()
    var rootView: InternalMenuRootView? {
        self.view as? InternalMenuRootView
    }

    override func loadView() {
        self.view = InternalMenuRootView(viewModel: viewModel)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.title
        guard let rootView = self.rootView else {
            return
        }
        if !rootView.viewNotReady {
            rootView.tableView.reloadData()
        }
        addDismissButton()
        observeViewModel()
    }

    func addDismissButton() {
        let dismissBarButtonItem: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissAction))
        navigationItem.rightBarButtonItem = dismissBarButtonItem
    }

    @objc
    func dismissAction() {
        self.dismiss(animated: true, completion: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    private func observeViewModel() {
      let observable = self.viewModel.viewStatus.distinctUntilChanged()
      subscribe(to: observable)
    }

    func subscribe(to observable: Observable<InternalViewResponder>) {
      observable.subscribe(onNext: { [weak self] viewResponder in
        guard let `self` = self else { return }
        self.present(viewResponder)
      }).disposed(by: disposeBag)
    }

    func present(_ viewResponder: InternalViewResponder) {
      switch viewResponder {
      case .designDemo:
        navigateToDesginDemo()
      case .none:
        break
      }
    }

    func navigateToDesginDemo() {
        let vc = DesginDemoViewCotroller()
        show(vc, sender: nil)
    }
}
