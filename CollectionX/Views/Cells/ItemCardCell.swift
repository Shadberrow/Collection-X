//
//  ItemCardCell.swift
//  CollectionX
//
//  Created by Yevhenii on 12.05.2020.
//  Copyright © 2020 Yevhenii. All rights reserved.
//

import UIKit
import YVAnchor

class ItemCardCell: UICollectionViewCell {

    private var placeholderImageView: UIImageView!
    private var posterImageView: CachedImageView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func setupView() {
        layer.cornerRadius = 12
        clipsToBounds = true
        backgroundColor = .secondarySystemBackground

        setupSubviews()
        addSubviews()
        setupConstraints()
    }

    private func setupSubviews() {
        placeholderImageView = UIImageView(image: Images.logo_placeholder)
        placeholderImageView.tintColor = UIColor.label
        placeholderImageView.contentMode = .scaleAspectFit

        posterImageView = CachedImageView()
        posterImageView.contentMode = .scaleAspectFill
    }

    private func addSubviews() {
        addSubview(placeholderImageView)
        addSubview(posterImageView)
    }

    private func setupConstraints() {
        placeholderImageView.centered(in: self)
        placeholderImageView.square(70)

        posterImageView.fill(in: self)
    }

    func setup(withImageURLSting stringURL: String) {
        posterImageView.downloadImage(stringUrl: stringURL)
    }

}

