//
//  FavoriteItemCell.swift
//  CollectionX
//
//  Created by Yevhenii on 26.05.2020.
//  Copyright © 2020 Yevhenii. All rights reserved.
//

import UIKit
import YVAnchor

class FavoriteItemCell: UITableViewCell {

    private var posterImageView     : CachedImageView!
    private var titleLabel          : UILabel!
    private var IMDBRatingImageView : UIImageView!
    private var IMDBRatingLabel     : UILabel!
    private var userRatingImageView : UIImageView!
    private var userRatingLabel     : UILabel!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func setupView() {

        setupSubviews()
        addSubviews()
        setupConstraints()
    }

    private func setupSubviews() {
        posterImageView         = CachedImageView()
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.clipsToBounds = true
        
        titleLabel              = UILabel()
        IMDBRatingImageView     = UIImageView()
        IMDBRatingLabel         = UILabel()
        userRatingImageView     = UIImageView()
        userRatingLabel         = UILabel()
    }

    private func addSubviews() {
        addSubview(posterImageView)
        addSubview(titleLabel)
        addSubview(IMDBRatingImageView)
        addSubview(IMDBRatingLabel)
        addSubview(userRatingImageView)
        addSubview(userRatingLabel)
    }

    private func setupConstraints() {
        posterImageView.pin(.top, to: self.top, constant: 8)
        posterImageView.pin(.leading, to: self.leading, constant: 16)
        posterImageView.pin(.bottom, to: self.bottom, constant: 8)
        posterImageView.width(equalTo: posterImageView.height, multiplier: 2/3)

        titleLabel.pin(.top, to: self.top, constant: 8)
        titleLabel.pin(.leading, to: posterImageView.trailing, constant: 8)
        titleLabel.pin(.trailing, to: self.trailing, constant: 16)


    }

    func setup(with item: OMDBItemFullInfo) {
        posterImageView.downloadImage(stringUrl: item.posterUrl)
        titleLabel.text = item.title
    }

}
