//
//  OMDBItemStatus.swift
//  CollectionX
//
//  Created by Yevhenii on 28.05.2020.
//  Copyright © 2020 Yevhenii. All rights reserved.
//

import Foundation

enum ItemStatusType {
    case favorited
    case bookmarked
    case checkedIn
}

struct OMDBItemStatus: Codable, Hashable {

    var isFavorited      = false
    var isBookmarked    = false
    var isCheckedIn     = false

    let imdbID: String

    init(id: String) {
        imdbID = id
    }

    mutating func set(value: Bool, forStatus type: ItemStatusType) {
        switch type {
        case .favorited:    isFavorited = value
        case .bookmarked:   isBookmarked = value
        case .checkedIn:    isCheckedIn = value
        }
    }

}
