//
//  ItemTitleInfo.swift
//  CollectionX
//
//  Created by Yevhenii on 09.06.2020.
//  Copyright © 2020 Yevhenii. All rights reserved.
//

import UIKit
import YVAnchor

class ItemTitleInfo: UITableViewCell {

    private var titleLabel   : UILabel!
    private var subtitleLabel: UILabel!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func setupView() {
        backgroundColor = .clear
        separatorInset = UIEdgeInsets(top: 0, left: UIScreen.main.bounds.width, bottom: 0, right: 0)
        selectionStyle = .none

        setupSubviews()
        addSubviews()
        setupConstraints()
    }

    private func setupSubviews() {
        titleLabel = UILabel()
        titleLabel.text = "Loading..."
        titleLabel.textColor = .label
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.preferredFont(forTextStyle: .title1, withTrait: .traitBold)
        titleLabel.adjustsFontForContentSizeCategory = true
        titleLabel.clipsToBounds = false

        subtitleLabel = UILabel()
        subtitleLabel.text = "Loading..."
        subtitleLabel.textColor = .label
        subtitleLabel.numberOfLines = 0
        subtitleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        subtitleLabel.adjustsFontForContentSizeCategory = true
    }

    private func addSubviews() {
        addSubview(titleLabel)
        addSubview(subtitleLabel)
    }

    private func setupConstraints() {
        titleLabel.pin(.top, to: self.top, constant: 16)
        titleLabel.pin(.leading, to: self.leading, constant: 16)
        titleLabel.pin(.trailing, to: self.trailing, constant: 70)

        subtitleLabel.pin(.top, to: titleLabel.bottom)
        subtitleLabel.pin(.leading, to: titleLabel.leading)
        subtitleLabel.pin(.trailing, to: titleLabel.trailing)
        subtitleLabel.pin(.bottom, to: self.bottom, constant: 16)
    }

    func setup(title: String?, subtitle: String?) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
    }

}
