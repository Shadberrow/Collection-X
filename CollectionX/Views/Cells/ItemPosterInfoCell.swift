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
    private var plotTextView: UITextView!
    private var imdbInfoView: UIView!

    private var rateBlurView: UIView!
    private var rateButton: UIButton!
    private var rateHint: UILabel!
    private var rateView: StarRatingView!
    private var rateValue: UILabel!

    private(set) var rating = 0

    private var rateViewBottomAnchor: NSLayoutConstraint!

    var ratingDidUpdated: ((Int) -> Void)?

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
        containerView.layer.masksToBounds = true

        posterImageView = CachedImageView(cornerRadius: 12, placeholder: Images.logo_placeholder)
        posterImageView.tintColor = .label
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
        imdbRatingLabel.font = UIFont.systemFont(ofSize: 13, weight: .semibold)

        imdbVotesLabel = UILabel()
        imdbVotesLabel.text = "..."
        imdbVotesLabel.textColor = .secondaryLabel
        imdbVotesLabel.font = UIFont.monospacedSystemFont(ofSize: 9, weight: .regular)

        plotTextView = UITextView()
        plotTextView.text = "Loading..."
        plotTextView.font = UIFont.preferredFont(forTextStyle: .body)
        plotTextView.isScrollEnabled = false
        plotTextView.isSelectable = false
        plotTextView.textColor = .label
        plotTextView.backgroundColor = .clear
        plotTextView.textContainerInset = .zero
        plotTextView.textContainer.lineFragmentPadding = 0
        plotTextView.textContainer.lineBreakMode = .byTruncatingTail

        rateBlurView = UIVisualEffectView(effect: UIBlurEffect(style: .systemThinMaterial))
        rateBlurView.alpha = 0
        rateBlurView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleRate)))

        rateButton = UIButton(type: .system)
        rateButton.backgroundColor = .tertiarySystemBackground
        rateButton.setTitle("RATE", for: .normal)
        rateButton.titleLabel?.textAlignment = .center
        rateButton.titleLabel?.font = UIFont.systemFont(ofSize: 11, weight: .semibold)
        rateButton.tintColor = .label
        rateButton.layer.cornerRadius = 6
        rateButton.addTarget(self, action: #selector(handleRate), for: .touchUpInside)

        rateHint = UILabel()
        rateHint.text = "This is your personal rating"
        rateHint.numberOfLines = 2
        rateHint.textAlignment = .right
        rateHint.textColor = .secondaryLabel
        rateHint.font = UIFont.systemFont(ofSize: 8, weight: .bold)

        rateView = StarRatingView(maxStars: 10)
        rateView.backgroundColor = .tertiarySystemBackground
        rateView.layer.cornerRadius = 6
        rateView.alpha = 0
        rateView.delegate = self

        rateValue = UILabel()
    }

    private func addSubviews() {
        addSubview(containerView)
        containerView.addSubview(posterImageView)
        containerView.addSubview(imdbInfoView)
        imdbInfoView.addSubview(imdbLogoImageView)
        imdbInfoView.addSubview(imdbRatingLabel)
        imdbInfoView.addSubview(imdbVotesLabel)
        containerView.addSubview(plotTextView)

        containerView.addSubview(rateBlurView)
        containerView.addSubview(rateButton)
        containerView.addSubview(rateHint)
        containerView.addSubview(rateView)
//        rateView.addSubview(rateStarsView)
        containerView.addSubview(rateValue)
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
        posterHeightConstraint.priority = .init(1e3)

        imdbInfoView.pin(.top, to: posterImageView.bottom, constant: 6)
        let imdbInfoViewBottomAnchor = imdbInfoView.pin(.bottom, to: containerView.bottom, constant: 16)
        imdbInfoViewBottomAnchor.priority = .init(749)
        imdbInfoView.pin(.trailing, to: imdbRatingLabel.trailing)
        imdbInfoView.centerX(in: posterImageView)
        imdbInfoView.height(25)

        imdbLogoImageView.pin(.top, to: imdbInfoView.top)
        imdbLogoImageView.pin(.leading, to: imdbInfoView.leading)
        imdbLogoImageView.pin(.bottom, to: imdbInfoView.bottom)
        imdbLogoImageView.width(46)

        imdbRatingLabel.pin(.top, to: imdbLogoImageView.top)
        imdbRatingLabel.pin(.leading, to: imdbLogoImageView.trailing, constant: 8)

        imdbVotesLabel.pin(.bottom, to: imdbLogoImageView.bottom)
        imdbVotesLabel.pin(.leading, to: imdbRatingLabel.leading)

        plotTextView.pin(.top, to: posterImageView.top)
        plotTextView.pin(.leading, to: posterImageView.trailing, constant: 12)
        plotTextView.pin(.trailing, to: containerView.trailing, constant: 16)
        let plotTextViewBottomAnchor = plotTextView.pin(.bottom, to: containerView.bottom, constant: 16)
        plotTextViewBottomAnchor.priority = .init(1e3)

        rateBlurView.fill(in: containerView)

        rateButton.pin(.trailing, to: containerView.trailing, constant: 16)
        rateButton.size(width: 65, height: 25)
        rateButton.pin(.bottom, to: containerView.bottom, constant: 16)

        rateHint.pin(.top, to: rateButton.top)
        rateHint.pin(.bottom, to: rateButton.bottom)
        rateHint.pin(.trailing, to: rateButton.leading, constant: 8)
        rateHint.width(70)

//        rateView.pin(.trailing, to: containerView.trailing, constant: 16)
        rateView.width(equalTo: containerView.width, multiplier: 0.8)
        rateView.centered(in: containerView)
//        rateViewBottomAnchor = rateView.pin(.bottom, to: rateButton.bottom)
        rateView.height(45)
    }

    func setup(forItemInfo item: Item?) {
        posterImageView.downloadImage(stringUrl: item?.info.posterUrl)

        guard let item = item else { return }
        plotTextView.text = item.info.plot
        imdbRatingLabel.text = "\(item.info.imdbRating)/10"
        imdbVotesLabel.text = item.info.imdbVotes

        guard let rating = item.status.userRating else { return }
        rateView.setRating(rating)
    }

    @objc
    private func handleRate() {
//        rateViewBottomAnchor.constant = self.rateView.alpha == 0 ? -48 : 0

        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.rateBlurView.alpha = self.rateBlurView.alpha == 0 ? 1 : 0

            self.rateView.alpha = self.rateView.alpha == 0 ? 1 : 0
            self.containerView.layoutIfNeeded()
        })
    }

}

extension ItemPosterInfoCell: StarRatingViewDelegate {

    func starViewDidRate(_ view: StarRatingView, rating: Int) {
        rateButton.setTitle("\(rating)/10", for: .normal)
        self.rating = rating
        self.ratingDidUpdated?(rating)
    }

}
