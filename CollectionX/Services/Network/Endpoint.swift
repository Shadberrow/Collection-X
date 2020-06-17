//
//  Endpoint.swift
//  CollectionX
//
//  Created by Yevhenii on 27.05.2020.
//  Copyright © 2020 Yevhenii. All rights reserved.
//

import Foundation

struct Endpoint {
    
    let path        : String
    let queryItems  : [URLQueryItem]

    var url: URL? {
        var components          = URLComponents()
        components.scheme       = ApiAgent.scheme
        components.host         = ApiAgent.base
        components.path         = path
        components.queryItems   = queryItems
        return components.url
    }
    
}

extension Endpoint {

    static func matching(query: String, page: Int = 1) -> Endpoint {
        return Endpoint(path: "", queryItems: [
            URLQueryItem(name: ApiAgent.Key.api, value: ApiAgent.apiKey),
            URLQueryItem(name: ApiAgent.Key.search, value: query),
            URLQueryItem(name: ApiAgent.Key.page, value: "\(page)")
        ])
    }

    static func imdbID(_ id: String) -> Endpoint {
        return Endpoint(path: "", queryItems: [
            URLQueryItem(name: ApiAgent.Key.api, value: ApiAgent.apiKey),
            URLQueryItem(name: ApiAgent.Key.imdbId, value: id)
        ])
    }

}
