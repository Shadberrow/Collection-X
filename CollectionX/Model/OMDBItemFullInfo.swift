//
//  OMDBItemFullInfo.swift
//  CollectionX
//
//  Created by Yevhenii on 27.05.2020.
//  Copyright © 2020 Yevhenii. All rights reserved.
//

import Foundation

struct OMDBItemFullInfo: Codable, Hashable {

    enum CodingKeys: String, CodingKey {
        case title       = "Title"
        case year        = "Year"
        case released    = "Released"
        case runtime     = "Runtime"
        case genre       = "Genre"
        case actors      = "Actors"
        case posterUrl   = "Poster"
        case rated       = "Rated"
        case imdbRating  = "imdbRating"
        case imdbVotes   = "imdbVotes"
        case imdbID      = "imdbID"
        case type        = "Type"
        case plot        = "Plot"
        case director    = "Director"
        case writer      = "Writer"
    }

    let title       : String
    let year        : String
    let released    : String
    let runtime     : String
    let genre       : String
    let actors      : String
    let posterUrl   : String
    let rated       : String
    let imdbRating  : String
    let imdbVotes   : String
    let imdbID      : String
    let type        : String
    let plot        : String
    let director    : String
    let writer      : String

    var prettyYear: String {
        return year.last?.isNumber ?? false ? year : year + "?"
    }

    var prettyRuntime: String {
        let minutesString = runtime.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        guard let minutesInt = Int(minutesString) else { return "?m" }
        let minutes = minutesInt % 60
        let hours = minutesInt / 60
        
        return minutesInt == 60 ? "\(minutesInt)m" : (minutesInt < 60 ? "\(minutes)m" : "\(hours)h \(minutes)m")
    }

    var prettySubinfo: String {
        return "\(prettyYear)   \(rated)   \(prettyRuntime)   \(type.prefix(1).capitalized + type.dropFirst())"
    }

}
