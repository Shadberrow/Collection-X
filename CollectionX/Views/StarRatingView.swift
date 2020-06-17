//
//  StarRatingView.swift
//  CollectionX
//
//  Created by Yevhenii on 12.06.2020.
//  Copyright © 2020 Yevhenii. All rights reserved.
//

import UIKit
import YVAnchor


protocol StarRatingViewDelegate: class {
    func starViewDidRate(_ view: StarRatingView, rating: Int)
}


class StarRatingView: UIView {

    private(set) var maxStars: Int = 0 { didSet { updateUI() } }
    private(set) var currentRating: Int = 0 { didSet { delegate?.starViewDidRate(self, rating: currentRating) } }

    private var stackView: UIStackView!
    private var starViews: [UIImageView] = []

    private var n: Int = 0
    private var oneStarWidth: CGFloat {
        return frame.width / CGFloat(maxStars)
    }

    weak var delegate: StarRatingViewDelegate?

    convenience init(maxStars: Int) {
        self.init(frame: .zero)
        defer {
            self.maxStars = maxStars
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func setupView() {
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture)))
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapGesture)))

        setupSubviews()
        addSubviews()
        setupConstraints()
    }

    private func setupSubviews() {
        stackView = UIStackView()
        stackView.spacing = 0
        stackView.distribution = .fillEqually
    }

    private func addSubviews() {
        addSubview(stackView)
    }

    private func setupConstraints() {
        stackView.fill(in: self, constants: .init(top: 3, left: 8, bottom: 3, right: 8))
    }

    private func updateUI() {
        for _ in 0..<maxStars {
            let view = UIImageView(image: SFSymbols.star)
            view.contentMode = .scaleAspectFit
            view.tintColor = .systemGray

            starViews.append(view)
            stackView.addArrangedSubview(view)
        }
    }

    private func rate(_ value: Int) {
        var ratingToSet = currentRating + value
        if ratingToSet >= maxStars {
            ratingToSet = maxStars
        } else if ratingToSet < 0 {
            ratingToSet = 0
        }

        for (idx, img) in starViews.enumerated() {
            if idx < ratingToSet {
                img.image = SFSymbols.starFill
                img.tintColor = .systemYellow
            } else {
                img.image = SFSymbols.star
                img.tintColor = .systemGray
            }
        }
    }

    private func updateCurrentRating(_ value: Int) {
        var ratingToSet = currentRating + value
        if ratingToSet >= maxStars {
            ratingToSet = maxStars
        } else if ratingToSet < 0 {
            ratingToSet = 0
        }

        currentRating = ratingToSet
    }

    @objc
    private func handlePanGesture(_ sender: UIPanGestureRecognizer) {
        let x = sender.translation(in: self).x

        switch sender.state {
        case .changed:
            n = Int(ceilf(Float(x/oneStarWidth/0.5)))
            rate(n)
        case .ended:
            updateCurrentRating(n)
        default: return
        }
    }

    @objc
    private func handleTapGesture(_ sender: UITapGestureRecognizer) {
        let x = sender.location(in: self).x

        n = Int(ceilf(Float(x/oneStarWidth)))

        for (idx, img) in starViews.enumerated() {
            if idx < n {
                img.image = SFSymbols.starFill
                img.tintColor = .systemYellow
            } else {
                img.image = SFSymbols.star
                img.tintColor = .systemGray
            }
        }

        currentRating = n
    }

    func setRating(_ value: Int) {
        var ratingToSet = value
        if ratingToSet >= maxStars {
            ratingToSet = maxStars
        } else if ratingToSet < 0 {
            ratingToSet = 0
        }

        for (idx, img) in starViews.enumerated() {
            if idx < ratingToSet {
                img.image = SFSymbols.starFill
                img.tintColor = .systemYellow
            } else {
                img.image = SFSymbols.star
                img.tintColor = .systemGray
            }
        }

        currentRating = ratingToSet
    }

}
