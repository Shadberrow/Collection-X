//
//  OMDBItem.swift
//  CollectionX
//
//  Created by Yevhenii on 27.05.2020.
//  Copyright © 2020 Yevhenii. All rights reserved.
//

import Foundation

struct OMDBItem: Codable, Hashable {

    enum CodingKeys: String, CodingKey {
        case title  = "Title"
        case year   = "Year"
        case imdbID = "imdbID"
        case type   = "Type"
        case poster = "Poster"
    }

    let title   : String
    let year    : String
    let imdbID  : String
    let type    : String
    let poster  : String

}
