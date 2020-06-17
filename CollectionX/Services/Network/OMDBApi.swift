//
//  OMDBApi.swift
//  CollectionX
//
//  Created by Yevhenii on 27.05.2020.
//  Copyright © 2020 Yevhenii. All rights reserved.
//

import Foundation
import Combine

enum OMDBApiError: String, Error {

    case badURL = "Bad URL."

}

enum OMDBApi {

    private static let agent = ApiAgent()

    static func search<T: Codable>(_ endpoint: Endpoint) -> AnyPublisher<T, Error> {
        guard let url = endpoint.url else { return Fail(error: OMDBApiError.badURL).eraseToAnyPublisher() }
        print(url)
        return agent.run(url)
            .eraseToAnyPublisher()
    }

}


extension OMDBApi {

    enum Key {
        static let api       = "apiKey"
        static let search    = "s"
        static let imdbId    = "i"
        static let title     = "t"
        static let page      = "page"
    }

    static let apiKey   = "bf4ec98b"

}
