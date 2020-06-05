//
//  ApiAgent.swift
//  CollectionX
//
//  Created by Yevhenii on 27.05.2020.
//  Copyright © 2020 Yevhenii. All rights reserved.
//

import Foundation
import Combine

struct ApiAgent {

    enum Key {
        static let api       = "apiKey"
        static let search    = "s"
        static let imdbId    = "i"
        static let title     = "t"
        static let page      = "page"
    }

    static let base     = "www.omdbapi.com"
    static let scheme   = "https"
    static let apiKey   = "bf4ec98b"

    func run<T: Decodable>(_ url: URL, _ decoder: JSONDecoder = JSONDecoder()) -> AnyPublisher<T, Error> {
        return URLSession.shared
            .dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: T.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
    
}
