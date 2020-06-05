//
//  OMDBSearchResponse.swift
//  CollectionX
//
//  Created by Yevhenii on 27.05.2020.
//  Copyright © 2020 Yevhenii. All rights reserved.
//

import Foundation

struct OMDBSearchResponse: Codable {

    enum CodingKeys: String, CodingKey {
        case items = "Search"
        case totalResults = "totalResults"
    }

    let items: [OMDBItem]
    let totalResults: String

}
