//
//  Constants.swift
//  CollectionX
//
//  Created by Yevhenii on 11.05.2020.
//  Copyright © 2020 Yevhenii. All rights reserved.
//

import UIKit

enum SFSymbols {

    static let archiveBox       = UIImage(systemName: "archivebox")
    static let archiveBoxFill   = UIImage(systemName: "archivebox.fill")
    static let bookmark         = UIImage(systemName: "bookmark")
    static let bookmarkFill     = UIImage(systemName: "bookmark.fill")
    static let star             = UIImage(systemName: "star")
    static let starFill         = UIImage(systemName: "star.fill")
    static let magnifyingGlass  = UIImage(systemName: "magnifyingglass")
    static let gear             = UIImage(systemName: "gear")
    static let xMark            = UIImage(systemName: "xmark.circle.fill")
    static let cards            = UIImage(systemName: "rectangle.fill.on.rectangle.angled.fill")

}

enum Images {

    static let logo_placeholder = UIImage(named: "logo_placehold")
    static let logo_imdb        = UIImage(named: "logo_imdb")

}

typealias ToggleTitle = (enabled: String, disabled: String)

enum Text {

    static let empty = ("", "")

    static let favorite: ToggleTitle  = (NSLocalizedString("Favorited", comment: ""), NSLocalizedString("Favorite", comment: ""))
    static let watchlist: ToggleTitle = (NSLocalizedString("Watchlisted", comment: ""), NSLocalizedString("Watchlist", comment: ""))
    static let checkIn: ToggleTitle   = (NSLocalizedString("Checked-in", comment: ""), NSLocalizedString("Check-in", comment: ""))

}
