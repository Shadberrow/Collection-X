//
//  ItemBasicInfoCell.swift
//  CollectionX
//
//  Created by Yevhenii on 04.06.2020.
//  Copyright © 2020 Yevhenii. All rights reserved.
//

import UIKit
import YVAnchor

class ItemPosterInfoCell: UITableViewCell {

    private var containerView: UIView!
    private var posterImageView: CachedImageView!
    private var imdbLogoImageView: UIImageView!
    private var imdbRatingLabel: UILabel!
    private var imdbVotesLabel: UILabel!
    private var plotLabel: UITextView!
    private var imdbInfoView: UIView!

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

        posterImageView = CachedImageView(cornerRadius: 12, placeholder: Images.logo_placeholder)
        posterImageView.tintColor = .black
        posterImageView.contentMode = .scaleAspectFit
        posterImageView.clipsToBounds = true

        imdbInfoView = UIView()

        imdbLogoImageView = UIImageView(image: Images.logo_imdb)
        imdbLogoImageView.contentMode = .scaleAspectFill
        imdbLogoImageView.clipsToBounds = true
        imdbLogoImageView.layer.cornerRadius = 4

        imdbRatingLabel = UILabel()
        imdbRatingLabel.text = "..."
        imdbRatingLabel.textColor = .label
        imdbRatingLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)

        imdbVotesLabel = UILabel()
        imdbVotesLabel.text = "..."
        imdbVotesLabel.textColor = .secondaryLabel
        imdbVotesLabel.font = UIFont.systemFont(ofSize: 8, weight: .regular)

        plotLabel = UITextView()
        plotLabel.text = "Loading..."
        plotLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        plotLabel.isScrollEnabled = false
        plotLabel.isSelectable = false
        plotLabel.textColor = .label
        plotLabel.backgroundColor = .clear
        plotLabel.textContainerInset = .zero
        plotLabel.textContainer.lineFragmentPadding = 0
        plotLabel.textContainer.lineBreakMode = .byTruncatingTail
    }

    private func addSubviews() {
        addSubview(containerView)
        containerView.addSubview(posterImageView)
        containerView.addSubview(imdbInfoView)
        imdbInfoView.addSubview(imdbLogoImageView)
        imdbInfoView.addSubview(imdbRatingLabel)
        imdbInfoView.addSubview(imdbVotesLabel)
        containerView.addSubview(plotLabel)
    }

    private func setupConstraints() {
        containerView.pin(.top, to: self.top, constant: 4)
        containerView.pin(.leading, to: self.leading, constant: 16)
        containerView.pin(.trailing, to: self.trailing, constant: 16)
        containerView.pin(.bottom, to: self.bottom, constant: 4)

        posterImageView.pin(.top, to: containerView.top, constant: 16)
        posterImageView.pin(.leading, to: containerView.leading, constant: 16)
        posterImageView.width(equalTo: posterImageView.height, multiplier: 2/3)
        let posterHeightConstraint = posterImageView.height(170)
        posterHeightConstraint.priority = .init(999)

        imdbInfoView.pin(.top, to: posterImageView.bottom, constant: 6)
        imdbInfoView.pin(.bottom, to: containerView.bottom, constant: 16)
        imdbInfoView.pin(.trailing, to: imdbRatingLabel.trailing)
        imdbInfoView.centerX(in: posterImageView)
        imdbInfoView.height(25)

        imdbLogoImageView.pin(.top, to: imdbInfoView.top)
        imdbLogoImageView.pin(.leading, to: imdbInfoView.leading)
        imdbLogoImageView.pin(.bottom, to: imdbInfoView.bottom)
        imdbLogoImageView.width(45)

        imdbRatingLabel.pin(.top, to: imdbLogoImageView.top)
        imdbRatingLabel.pin(.leading, to: imdbLogoImageView.trailing, constant: 8)

        imdbVotesLabel.pin(.bottom, to: imdbLogoImageView.bottom)
        imdbVotesLabel.pin(.leading, to: imdbRatingLabel.leading)

        plotLabel.pin(.top, to: posterImageView.top)
        plotLabel.pin(.leading, to: posterImageView.trailing, constant: 12)
        plotLabel.pin(.trailing, to: containerView.trailing, constant: 16)
        let plotLabelConstraint = plotLabel.pin(.bottom, to: containerView.bottom, constant: 16)
        plotLabelConstraint.priority = .init(100)
    }

    func setup(forItemInfo item: OMDBItemFullInfo?) {
        posterImageView.downloadImage(stringUrl: item?.posterUrl)

        guard let item = item else { return }
        plotLabel.text = item.plot
        imdbRatingLabel.text = "\(item.imdbRating)/10"
        imdbVotesLabel.text = item.imdbVotes
    }

}
