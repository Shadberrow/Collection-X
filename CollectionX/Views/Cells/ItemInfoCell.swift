//
//  ItemInfoCell.swift
//  CollectionX
//
//  Created by Yevhenii on 04.06.2020.
//  Copyright © 2020 Yevhenii. All rights reserved.
//

import UIKit
import YVAnchor

class ItemInfoCell: UITableViewCell {

    private var containerView: UIView!
    private var verticalLineView: UIView!
    private var itemInfoTitle: UILabel!
    private var itemInfoDescription: UILabel!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func setupView() {
        backgroundColor = .clear
        selectionStyle = .none
        separatorInset = UIEdgeInsets(top: 0, left: UIScreen.main.bounds.width, bottom: 0, right: 0)

        setupSubviews()
        addSubviews()
        setupConstraints()
    }

    private func setupSubviews() {
        containerView = UIView()
        containerView.backgroundColor = .systemGroupedBackground
        containerView.layer.cornerRadius = 18

        verticalLineView = UIView()
        verticalLineView.layer.cornerRadius = 2
        verticalLineView.backgroundColor = .systemYellow

        itemInfoTitle = UILabel()
        itemInfoTitle.font = UIFont.systemFont(ofSize: 24, weight: .heavy)

        itemInfoDescription = UILabel()
        itemInfoDescription.numberOfLines = 0
        itemInfoDescription.font = UIFont.systemFont(ofSize: 16, weight: .regular)
    }

    private func addSubviews() {
        addSubview(containerView)
        containerView.addSubview(verticalLineView)
        containerView.addSubview(itemInfoTitle)
        containerView.addSubview(itemInfoDescription)
    }

    private func setupConstraints() {
        containerView.pin(.top, to: self.top, constant: 4)
        containerView.pin(.leading, to: self.leading, constant: 16)
        containerView.pin(.trailing, to: self.trailing, constant: 16)
        containerView.pin(.bottom, to: self.bottom, constant: 4)

        itemInfoTitle.pin(.top, to: containerView.top, constant: 16)
        itemInfoTitle.pin(.leading, to: verticalLineView.trailing, constant: 6)
        itemInfoTitle.pin(.trailing, to: containerView.trailing, constant: 16)

        verticalLineView.pin(.top, to: itemInfoTitle.top)
        verticalLineView.pin(.leading, to: containerView.leading, constant: 16)
        verticalLineView.pin(.bottom, to: itemInfoTitle.bottom)
        verticalLineView.width(4)

        itemInfoDescription.pin(.top, to: itemInfoTitle.bottom, constant: 8)
        itemInfoDescription.pin(.leading, to: verticalLineView.leading)
        itemInfoDescription.pin(.trailing, to: containerView.trailing, constant: 16)
        itemInfoDescription.pin(.bottom, to: containerView.bottom, constant: 16)
    }

    func setup(title: String, description: String) {
        itemInfoTitle.text = title
        itemInfoDescription.text = description
    }

}
