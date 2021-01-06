//
//  OMDBApi.swift
//  CollectionX
//
//  Created by Yevhenii on 27.05.2020.
//  Copyright © 2020 Yevhenii. All rights reserved.
//

import Foundation

//enum TMDBApi {
//    enum Key {
//        static let api = "api_key"
//        static let searchMulti = "/3/search/multi"
//        static let query = "query"
//        static let page = "page"
//    }
//    
//    static let base = "api.themoviedb.org"
//    static let scheme = "https"
//    static let apiKey = "0cb480d8266ccd447a1ae6509589b45f"
//    static let image500 = "https://image.tmdb.org/t/p/w500/"
//    static let image200 = "https://image.tmdb.org/t/p/w200/"
//}

enum VaporAPI {
    enum Key {
        static let search = "/api/items/search"
        static let title = "title"
        static let page = "page"
        static let per = "per"
    }
    
    static let base = "localhost"
    static let port = 8080
    static let scheme = "http"
}
