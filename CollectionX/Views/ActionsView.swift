//
//  ActionsView.swift
//  CollectionX
//
//  Created by Yevhenii on 12.05.2020.
//  Copyright © 2020 Yevhenii. All rights reserved.
//

import UIKit
import YVAnchor

protocol ActionsViewDelegate: class {
    func actionViewFavoriteDidTapped()
    func actionViewWatchlistDidTapped()
    func actionViewCheckInDidTapped()
}

class ActionsView: UIView {

    enum ConstraintState {
        case full, middle, hidden
    }

    private var favoriteBtn         : CXActionButton!
    private var watchlistBtn        : CXActionButton!
    private var checkInBtn          : CXActionButton!
    private var spacer              : UIView!

    private let fullSizeMultiplier  : CGFloat = 0.49
    private let middleSizeMultiplier: CGFloat = (1 - 0.02 - 0.02) / 3
    private let spacerSizeMultiplier: CGFloat = 0.02
    private let hiddenSizeConstant  : CGFloat = 0.00

    var isFavorited: Bool = false {
        didSet {
            favoriteBtn.set(actionState: isFavorited ? .active : .disabled)
        }
    }

    var isWatchlisted: Bool = false {
        didSet {
            watchlistBtn.set(actionState: isWatchlisted ? .active : .disabled)
            updateActionButtons()
        }
    }

    var isCheckedIn: Bool = false {
        didSet {
            checkInBtn.set(actionState: isCheckedIn ? .active : .disabled)
            updateActionButtons()
        }
    }

    private var favoriteBtnWidthConstraint_full     : NSLayoutConstraint!
    private var favoriteBtnWidthConstraint_middle   : NSLayoutConstraint!
    private var watchlistBtnWidthConstraint_full    : NSLayoutConstraint!
    private var watchlistBtnWidthConstraint_middle  : NSLayoutConstraint!
    private var watchlistBtnWidthConstraint_hidden  : NSLayoutConstraint!
    private var checkInBtnWidthConstraint_full      : NSLayoutConstraint!
    private var checkInBtnWidthConstraint_middle    : NSLayoutConstraint!
    private var checkInBtnWidthConstraint_hidden    : NSLayoutConstraint!

    weak var delegate: ActionsViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func setupView() {
        setupSubviews()
        addSubviews()
        setupConstraints()
    }

    private func setupSubviews() {
        spacer = UIView()

        favoriteBtn = CXActionButton(titles: Text.favorite, color: .systemYellow)
        favoriteBtn.addTarget(self, action: #selector(handleFavoriteAction), for: .touchUpInside)

        watchlistBtn = CXActionButton(titles: Text.watchlist, color: .systemRed)
        watchlistBtn.addTarget(self, action: #selector(handleWatchlistAction), for: .touchUpInside)

        checkInBtn = CXActionButton(titles: Text.checkIn, color: .systemGreen)
        checkInBtn.addTarget(self, action: #selector(handleCheckInAction), for: .touchUpInside)
    }

    private func addSubviews() {
        addSubview(favoriteBtn)
        addSubview(spacer)
        addSubview(watchlistBtn)
        addSubview(checkInBtn)
    }

    private func setupConstraints() {
        favoriteBtn.pin(.top, to: self.top)
        favoriteBtn.pin(.leading, to: self.leading)
        favoriteBtn.pin(.bottom, to: self.bottom)

        favoriteBtnWidthConstraint_middle = favoriteBtn.width(equalTo: self.width, multiplier: middleSizeMultiplier).deactivated()
        favoriteBtnWidthConstraint_full = favoriteBtn.width(equalTo: self.width, multiplier: fullSizeMultiplier)

        spacer.pin(.top, to: favoriteBtn.top)
        spacer.pin(.leading, to: favoriteBtn.trailing)
        spacer.pin(.bottom, to: favoriteBtn.bottom)
        spacer.width(equalTo: self.width, multiplier: spacerSizeMultiplier)

        watchlistBtn.pin(.top, to: self.top)
        watchlistBtn.pin(.leading, to: spacer.trailing)
        watchlistBtn.pin(.bottom, to: self.bottom)

        watchlistBtnWidthConstraint_full = watchlistBtn.width(equalTo: self.width, multiplier: fullSizeMultiplier)
        watchlistBtnWidthConstraint_middle = watchlistBtn.width(equalTo: self.width, multiplier: middleSizeMultiplier).deactivated()
        watchlistBtnWidthConstraint_hidden = watchlistBtn.width(hiddenSizeConstant).deactivated()

        checkInBtn.pin(.top, to: self.top)
        checkInBtn.pin(.trailing, to: self.trailing)
        checkInBtn.pin(.bottom, to: self.bottom)

        checkInBtnWidthConstraint_full = checkInBtn.width(equalTo: self.width, multiplier: fullSizeMultiplier).deactivated()
        checkInBtnWidthConstraint_middle = checkInBtn.width(equalTo: self.width, multiplier: middleSizeMultiplier).deactivated()
        checkInBtnWidthConstraint_hidden = checkInBtn.width(hiddenSizeConstant)
    }

    private func updateActionButtons() {
        if !isWatchlisted && !isCheckedIn {
            activateFavoriteBtnConstraints(forState: .full)
            activateWatchlistBtnConstraints(forState: .full)
            activateCheckInBtnConstraints(forState: .hidden)
        } else if isWatchlisted && !isCheckedIn {
            activateFavoriteBtnConstraints(forState: .middle)
            activateWatchlistBtnConstraints(forState: .middle)
            activateCheckInBtnConstraints(forState: .middle)
        } else if isCheckedIn {
            activateFavoriteBtnConstraints(forState: .full)
            activateWatchlistBtnConstraints(forState: .hidden)
            activateCheckInBtnConstraints(forState: .full)
        }
        animateLayoutIfNeeded()
    }


    private func activateFavoriteBtnConstraints(forState state: ConstraintState) {
        switch state {
        case .full:     favoriteBtnWidthConstraint_middle.isActive  = false
                        favoriteBtnWidthConstraint_full.isActive    = true

        case .middle:   favoriteBtnWidthConstraint_full.isActive    = false
                        favoriteBtnWidthConstraint_middle.isActive  = true
        default: return
        }
    }

    private func activateWatchlistBtnConstraints(forState state: ConstraintState) {
        switch state {
        case .full:     watchlistBtnWidthConstraint_middle.isActive = false
                        watchlistBtnWidthConstraint_hidden.isActive = false
                        watchlistBtnWidthConstraint_full.isActive   = true
                        animateViewAlpha(watchlistBtn, alpha: 1)

        case .middle:   watchlistBtnWidthConstraint_full.isActive   = false
                        watchlistBtnWidthConstraint_hidden.isActive = false
                        watchlistBtnWidthConstraint_middle.isActive = true
                        animateViewAlpha(watchlistBtn, alpha: 1)

        case .hidden:   watchlistBtnWidthConstraint_full.isActive   = false
                        watchlistBtnWidthConstraint_middle.isActive = false
                        watchlistBtnWidthConstraint_hidden.isActive = true
                        animateViewAlpha(watchlistBtn, alpha: 0)
        }
    }

    private func activateCheckInBtnConstraints(forState state: ConstraintState) {
        switch state {
        case .full:     checkInBtnWidthConstraint_middle.isActive   = false
                        checkInBtnWidthConstraint_hidden.isActive   = false
                        checkInBtnWidthConstraint_full.isActive     = true
                        animateViewAlpha(checkInBtn, alpha: 1)

        case .middle:   checkInBtnWidthConstraint_full.isActive     = false
                        checkInBtnWidthConstraint_hidden.isActive   = false
                        checkInBtnWidthConstraint_middle.isActive   = true
                        animateViewAlpha(checkInBtn, alpha: 1)

        case .hidden:   checkInBtnWidthConstraint_full.isActive     = false
                        checkInBtnWidthConstraint_middle.isActive   = false
                        checkInBtnWidthConstraint_hidden.isActive   = true
                        animateViewAlpha(checkInBtn, alpha: 0)
        }
    }

    private func animateLayoutIfNeeded() {
        UIView.animate(withDuration: 0.3, delay: 0,
                       usingSpringWithDamping: 1, initialSpringVelocity: 1,
                       options: .curveEaseInOut, animations: { self.layoutIfNeeded() })
    }

    private func animateViewAlpha(_ view: UIView, alpha: CGFloat) {
        UIView.animate(withDuration: 0.3, delay: 0,
                       usingSpringWithDamping: 1, initialSpringVelocity: 1,
                       options: .curveEaseInOut, animations: { view.alpha = alpha })
    }

    @objc
    private func handleFavoriteAction() { delegate?.actionViewFavoriteDidTapped() }

    @objc
    private func handleWatchlistAction() { delegate?.actionViewWatchlistDidTapped() }

    @objc
    private func handleCheckInAction() { delegate?.actionViewCheckInDidTapped() }

}
