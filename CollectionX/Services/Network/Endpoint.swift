//
//  Endpoint.swift
//  CollectionX
//
//  Created by Yevhenii on 27.05.2020.
//  Copyright © 2020 Yevhenii. All rights reserved.
//

import Foundation

struct Endpoint {
    
    var base: String { VaporAPI.base }
    var port: Int { VaporAPI.port }
    var scheme: String { VaporAPI.scheme }
    
    let path: String
    let queryItems: [URLQueryItem]
    
    var url: URL? {
        var components          = URLComponents()
        components.scheme       = scheme
        components.host         = base
        components.path         = path
        components.queryItems   = queryItems
        components.port         = port
        return components.url
    }
    
}

extension Endpoint {
    
    static func matching(query: String, page: Int = 1, per: Int = 20) -> Endpoint {
        return Endpoint(path: VaporAPI.Key.search, queryItems: [
            URLQueryItem(name: VaporAPI.Key.title, value: query),
            URLQueryItem(name: VaporAPI.Key.page, value: "\(page)"),
            URLQueryItem(name: VaporAPI.Key.per, value: "\(per)")
        ])
    }
    
}
