////
////  MovieInfoView.swift
////  CollectionX
////
////  Created by Yevhenii on 11.05.2020.
////  Copyright © 2020 Yevhenii. All rights reserved.
////
//
//import UIKit
//
//class MovieInfoView: UIView {
//
//    private var titleLabel: UILabel!
//    private var yearLabel: UILabel!
//    private var productionLabel: UILabel!
//    private var actorsLabel: UILabel!
//    private var genreLabel: UILabel!
//    private var imdbRatingLabel: UILabel!
//    private var imdbVotesLabel: UILabel!
//    private var actionsView: ActionsView!
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupView()
//    }
//
//    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
//
//    private func setupView() {
//        layer.cornerRadius = 18
//
//        setupSubviews()
//        addSubviews()
//        setupConstraints()
//    }
//
//    private func setupSubviews() {
//        titleLabel                           = UILabel()
//        titleLabel.font                      = UIFont.systemFont(ofSize: 28, weight: .bold)
//        titleLabel.textColor                 = .label
//        titleLabel.adjustsFontSizeToFitWidth = true
//        titleLabel.minimumScaleFactor        = 0.7
//        titleLabel.numberOfLines             = 3
//
//        yearLabel                            = UILabel()
//        yearLabel.font                       = UIFont.systemFont(ofSize: 12, weight: .regular)
//        yearLabel.textColor                  = .secondaryLabel
//        yearLabel.numberOfLines              = 1
//
//        productionLabel                      = UILabel()
////        productionLabel.font                 = UIFont.systemFont(ofSize: 17, weight: .regular)
//        productionLabel.textColor            = .label
//        productionLabel.numberOfLines        = 0
//
//        actorsLabel                          = UILabel()
////        actorsLabel.font                     = UIFont.systemFont(ofSize: 17, weight: .regular)
//        actorsLabel.textColor                = .label
//        actorsLabel.numberOfLines            = 0
//
//        genreLabel                           = UILabel()
////        genreLabel.font                      = UIFont.systemFont(ofSize: 17, weight: .regular)
//        genreLabel.textColor                 = .label
//        genreLabel.numberOfLines             = 0
//
//        imdbRatingLabel                      = UILabel()
//        imdbRatingLabel.font                 = UIFont.systemFont(ofSize: 20, weight: .heavy)
//        imdbRatingLabel.textColor            = .label
//        imdbRatingLabel.numberOfLines        = 1
//        imdbRatingLabel.textAlignment        = .right
//
//        imdbVotesLabel                       = UILabel()
//        imdbVotesLabel.font                  = UIFont.systemFont(ofSize: 12, weight: .medium)
//        imdbVotesLabel.textColor             = .secondaryLabel
//        imdbVotesLabel.numberOfLines         = 1
//        imdbVotesLabel.textAlignment         = .right
//
//        actionsView = ActionsView()
//        actionsView.delegate = self
//    }
//
//    private func addSubviews() {
//        addSubview(titleLabel)
//        addSubview(yearLabel)
//        addSubview(productionLabel)
//        addSubview(actorsLabel)
//        addSubview(genreLabel)
//        addSubview(imdbRatingLabel)
//        addSubview(imdbVotesLabel)
//        addSubview(actionsView)
//    }
//
//    private func setupConstraints() {
//        titleLabel.pin(.top, to: self.top, constant: 12)
//        titleLabel.pin(.leading, to: self.leading, constant: 16)
//        titleLabel.pin(.trailing, to: self.trailing, constant: 16)
//
//        yearLabel.pin(.top, to: titleLabel.bottom)
//        yearLabel.pin(.leading, to: self.leading, constant: 16)
//        yearLabel.pin(.trailing, to: self.trailing, constant: 16)
//
//        productionLabel.pin(.top, to: imdbVotesLabel.bottom, constant: 0)
//        productionLabel.pin(.leading, to: self.leading, constant: 16)
//        productionLabel.pin(.trailing, to: self.trailing, constant: 8)
//
//        actorsLabel.pin(.top, to: productionLabel.bottom, constant: 5)
//        actorsLabel.pin(.leading, to: self.leading, constant: 16)
//        actorsLabel.pin(.trailing, to: self.trailing, constant: 16)
//
//        genreLabel.pin(.top, to: actorsLabel.bottom, constant: 5)
//        genreLabel.pin(.leading, to: self.leading, constant: 16)
//        genreLabel.pin(.trailing, to: self.trailing, constant: 16)
//
//        imdbRatingLabel.pin(.bottom, to: yearLabel.bottom)
//        imdbRatingLabel.pin(.trailing, to: self.trailing, constant: 16)
//        imdbRatingLabel.width(125)
//        imdbRatingLabel.setContentCompressionResistancePriority(.init(rawValue: 1e3), for: .horizontal)
//
//        imdbVotesLabel.pin(.top, to: imdbRatingLabel.bottom)
//        imdbVotesLabel.pin(.trailing, to: self.trailing, constant: 16)
//
//        actionsView.pin(.top, to: genreLabel.bottom, constant: 16)
//        actionsView.pin(.leading, to: self.leading, constant: 16)
//        actionsView.pin(.trailing, to: self.trailing, constant: 16)
//        actionsView.pin(.bottom, to: self.safeAreaLayoutGuide.bottomAnchor, constant: 16)
//        actionsView.height(45)
//    }
//
//    func updateUI(with info: OMDBItemFullInfo) {
//        titleLabel.text                 = info.title
//        yearLabel.text                  = info.year
//        productionLabel.attributedText  = setupAttributetText(head: "Production: ", tail: "- - - - -")
//        actorsLabel.attributedText      = setupAttributetText(head: "Actors: ", tail: info.actors)
//        genreLabel.attributedText       = setupAttributetText(head: "Genre: ", tail: info.genre)
//        imdbRatingLabel.attributedText  = setupAttributetText(head: "IMDb ", headFont: UIFont.systemFont(ofSize: 20, weight: .heavy), tail: "\(info.imdbRating)/10")
//        imdbVotesLabel.text             = info.imdbVotes
//    }
//
//    private func setupAttributetText(head: String,
//                                     headFont: UIFont = UIFont.systemFont(ofSize: 18, weight: .bold),
//                                     tail: String,
//                                     tailFont: UIFont = UIFont.systemFont(ofSize: 16, weight: .regular)) -> NSAttributedString
//    {
//        let text = NSMutableAttributedString()
//        let head = NSAttributedString(string: head, attributes: [NSAttributedString.Key.font : headFont])
//        let tail = NSAttributedString(string: tail, attributes: [NSAttributedString.Key.font : tailFont])
//        text.append(head)
//        text.append(tail)
//        return text
//    }
//
//}
//
//
//extension MovieInfoView: ActionsViewDelegate {
//
//    func actionViewFavoriteDidTapped() {
//
//    }
//
//    func actionViewBookmarkDidTapped() {
//
//    }
//
//    func actionViewCheckInDidTapped() {
//
//    }
//
//}
