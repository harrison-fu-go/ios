//
//  InternalMenuRootView.swift
//  iGlasses
//
//  Created by Matthew on 2021/4/13.
//

import UIKit

class InternalMenuRootView: NiblessView {
    var viewNotReady = true

    let tableView: UITableView = configure(UITableView(frame: CGRect.zero, style: .grouped)) {
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = 44
        $0.register(InternalMenuDescriptionCell.self, forCellReuseIdentifier: InternalMenuItemType.description.rawValue)
        $0.register(InternalMenuActionTriggerCell.self, forCellReuseIdentifier: InternalMenuItemType.actionTrigger.rawValue)
        $0.register(InternalMenuFeatureToggleCell.self, forCellReuseIdentifier: InternalMenuItemType.featureToggle.rawValue)
    }

    private let viewModel: InternalMenuViewModel

    /// - Methods
    init(viewModel: InternalMenuViewModel, frame: CGRect = .zero) {
        self.viewModel = viewModel
        super.init(frame: frame)
    }

    override func didMoveToWindow() {
        guard viewNotReady else { return }
        constructViewHierarchy()
        activateConstraints()
        viewNotReady = false
        tableView.delegate = self
        tableView.dataSource = self
    }

    func constructViewHierarchy() {
        addSubview(tableView)
    }

    func activateConstraints() {
        activateConstraintsTableView()
    }

    func activateConstraintsTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        let top = tableView.topAnchor.constraint(equalTo: self.topAnchor)
        let leading = tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        let trailing = tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        let bottom = tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor)

        NSLayoutConstraint.activate([top, leading, trailing, bottom])
    }
}

extension InternalMenuRootView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sections.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.sections[section].title
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.sections[section].items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = viewModel.sections[indexPath.section].items[indexPath.row]
        let cellView = tableView.dequeueReusableCell(withIdentifier: item.type.rawValue)
        if let cell = cellView as? InternalMenuCellType {
            cell.update(with:item)
        }
        return cellView ?? UITableViewCell()
    }
}

extension InternalMenuRootView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = viewModel.sections[indexPath.section].items[indexPath.row]
        item.select()
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
