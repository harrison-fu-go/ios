//
//  DesignDemoViewController.swift
//  iGlasses
//
//  Created by Matthew on 2021/4/13.
//

import UIKit
import SnapKit

class DesginDemoViewCotroller: NiblessViewController {
    override func loadView() {
        self.view = UIView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        title = "设计示例"
        setupUI()
    }
}

extension DesginDemoViewCotroller {
    func setupUI() {
        view.backgroundColor = .systemBackground

        let scrollView: UIScrollView = configure(.init()) {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide.snp.topMargin)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottomMargin)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
        }

        let rootStackView: UIStackView = configure(.init(arrangedSubviews: [
            buildTypography(),
            buildColors(),
            buildFavoriteButtons()
        ])) {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.axis = .vertical
            $0.alignment = .leading
            $0.isLayoutMarginsRelativeArrangement = true
            $0.layoutMargins = UIEdgeInsets(top: 32, left: 16, bottom: 32, right: 16)
            $0.spacing = 16
        }
        scrollView.addSubview(rootStackView)

        rootStackView.snp.makeConstraints {
            $0.top.equalTo(scrollView.snp.top)
            $0.bottom.equalTo(scrollView.snp.bottom)
            $0.leading.equalTo(scrollView.snp.leading)
            $0.trailing.equalTo(scrollView.snp.trailing)
            $0.width.equalTo(scrollView.snp.width)
        }
    }

    func buildTypography() -> UIView {
        let items = [("display1", UIFont.designKit.display1),
                     ("display2", UIFont.designKit.display2),
                     ("title1", UIFont.designKit.title1),
                     ("title2", UIFont.designKit.title2),
                     ("title3", UIFont.designKit.title3),
                     ("title4", UIFont.designKit.title4),
                     ("title5", UIFont.designKit.title5),
                     ("bodyBold", UIFont.designKit.bodyBold),
                     ("body", UIFont.designKit.body),
                     ("captionBold", UIFont.designKit.captionBold),
                     ("caption", UIFont.designKit.caption),
                     ("small", UIFont.designKit.small)]
        // swiftlint:enable no_hardcoded_strings

        let title: UILabel = configure(.init()) {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.text = L10n.InternalMenu.typography
            $0.font = UIFont.designKit.title1
        }

        let stackView: UIStackView = configure(.init(arrangedSubviews: [title])) {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.axis = .vertical
            $0.spacing = 8
        }
        items.forEach {
            let item = $0
            let label: UILabel = configure(.init()) {
                $0.translatesAutoresizingMaskIntoConstraints = false
                $0.text = item.0
                $0.adjustsFontForContentSizeCategory = true
                $0.font = item.1
            }

            stackView.addArrangedSubview(label)
        }

        return stackView
    }

    func buildColors() -> UIView {
        let items = [("primary", UIColor.designKit.primary),
                     ("background", UIColor.designKit.background),
                     ("secondaryBackground", UIColor.designKit.secondaryBackground),
                     ("tertiaryBackground", UIColor.designKit.tertiaryBackground),
                     ("line", UIColor.designKit.line),
                     ("primaryText", UIColor.designKit.primaryText),
                     ("secondaryText", UIColor.designKit.secondaryText),
                     ("tertiaryText", UIColor.designKit.tertiaryText),
                     ("quaternaryText", UIColor.designKit.quaternaryText)]
        // swiftlint:enable no_hardcoded_strings

        let title: UILabel = configure(.init()) {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.text = L10n.InternalMenu.colors
            $0.font = UIFont.designKit.title1
        }

        let stackView: UIStackView = configure(.init(arrangedSubviews: [title])) {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.axis = .vertical
            $0.spacing = 8
        }
        items.forEach {
            let item = $0

            let label: UILabel = configure(.init()) {
                $0.translatesAutoresizingMaskIntoConstraints = false
                $0.text = item.0
                $0.textColor = UIColor.designKit.primaryText
            }

            let colorView: UIView = configure(.init()) {
                $0.translatesAutoresizingMaskIntoConstraints = false
                $0.backgroundColor = item.1
            }

            let length = 32
            colorView.snp.makeConstraints {
                $0.width.equalTo(length)
                $0.height.equalTo(length)
            }

            let innerStackView: UIStackView = configure(.init(arrangedSubviews: [label, colorView])) {
                $0.translatesAutoresizingMaskIntoConstraints = false
                $0.spacing = 8
                $0.distribution = .equalSpacing
            }

            stackView.addArrangedSubview(innerStackView)
        }

        return stackView
    }

    func buildFavoriteButtons() -> UIView {
        let title: UILabel = configure(.init()) {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.text = L10n.InternalMenu.favoriteButton
            $0.font = UIFont.designKit.title1
        }

        let starFavoriteButtonlabel: UILabel = configure(.init()) {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.text = L10n.InternalMenu.starFavoriteButton
            $0.textColor = UIColor.designKit.primaryText
        }

        let starFavoriteButton: UIButton = configure(.init()) {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.asStarFavoriteButton()
        }

        let starFavoriteButtonStackView: UIStackView = configure(.init(arrangedSubviews: [starFavoriteButtonlabel, starFavoriteButton])) {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.spacing = 8
        }

        let heartFavoriteButtonlabel: UILabel = configure(.init()) {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.text = L10n.InternalMenu.heartFavoriteButton
            $0.textColor = UIColor.designKit.primaryText
        }

        let heartFavoriteButton: UIButton = configure(.init()) {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.asHeartFavoriteButton()
        }

        let heartFavoriteButtonStackView: UIStackView = configure(.init(arrangedSubviews: [heartFavoriteButtonlabel, heartFavoriteButton])) {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.spacing = 8
        }

        let stackView: UIStackView = configure(.init(arrangedSubviews: [title, starFavoriteButtonStackView, heartFavoriteButtonStackView])) {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.axis = .vertical
            $0.spacing = 8
        }

        return stackView
    }
}
