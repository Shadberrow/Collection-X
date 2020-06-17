//
//  Endpoint.swift
//  CollectionX
//
//  Created by Yevhenii on 27.05.2020.
//  Copyright © 2020 Yevhenii. All rights reserved.
//

import Foundation

struct Endpoint: ApiAgentCallable {

    var base        : String { "www.omdbapi.com" }
    var scheme      : String { "https" }
    
    let path        : String
    let queryItems  : [URLQueryItem]

    var url: URL? {
        var components          = URLComponents()
        components.scheme       = scheme
        components.host         = base
        components.path         = path
        components.queryItems   = queryItems
        return components.url
    }
    
}

extension Endpoint {

    static func matching(query: String, page: Int = 1) -> Endpoint {
        return Endpoint(path: "", queryItems: [
            URLQueryItem(name: OMDBApi.Key.api, value: OMDBApi.apiKey),
            URLQueryItem(name: OMDBApi.Key.search, value: query),
            URLQueryItem(name: OMDBApi.Key.page, value: "\(page)")
        ])
    }

    static func imdbID(_ id: String) -> Endpoint {
        return Endpoint(path: "", queryItems: [
            URLQueryItem(name: OMDBApi.Key.api, value: OMDBApi.apiKey),
            URLQueryItem(name: OMDBApi.Key.imdbId, value: id)
        ])
    }

}
