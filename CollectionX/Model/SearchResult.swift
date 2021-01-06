//
//  SearchResult.swift
//  CollectionX
//
//  Created by Yevhenii Veretennikov on 10.11.2020.
//  Copyright © 2020 Yevhenii. All rights reserved.
//

import Foundation

protocol SearchItem {
    var id: String { get }
    var imdbID: String { get }
    var votes: Int { get }
    var rating: Double { get }
    var plot: String { get }
    var poster: String { get }
    var primaryTitle: String { get }
    var originalTitle: String { get }
    var startYear: String { get }
    var endYear: String { get }
    var runtimeMinutes: String { get }
    var genres: String { get }
}

protocol SearchMetadata {
    var per: Int { get }
    var total: Int { get }
    var page: Int { get }
}

protocol SearchResult {
    var items: [SearchItem] { get }
    var metadata: SearchMetadata { get }
}

struct APISearchItem: SearchItem, Hashable, Codable {
    var id: String
    var imdbID: String
    var votes: Int
    var rating: Double
    var plot: String
    var poster: String
    var primaryTitle: String
    var originalTitle: String
    var startYear: String
    var endYear: String
    var runtimeMinutes: String
    var genres: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(imdbID)
        hasher.combine(votes)
        hasher.combine(rating)
        hasher.combine(plot)
        hasher.combine(poster)
        hasher.combine(primaryTitle)
        hasher.combine(originalTitle)
        hasher.combine(startYear)
        hasher.combine(endYear)
        hasher.combine(runtimeMinutes)
        hasher.combine(genres)
    }
}

struct APISearchMetadata: SearchMetadata, Hashable, Codable {
    var per: Int
    var total: Int
    var page: Int
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(per)
        hasher.combine(total)
        hasher.combine(page)
    }
}

struct APISearchResult: Hashable, Codable {
    var items: [APISearchItem]
    var metadata: APISearchMetadata
}

extension APISearchItem: ItemCardPresentable {
    var imageUrlString: String {
        return poster
    }
}
