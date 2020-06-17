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

    func run<T: Decodable>(_ url: URL, _ decoder: JSONDecoder = JSONDecoder()) -> AnyPublisher<T, Error> {
        return URLSession.shared
            .dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: T.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
    
}

protocol ApiAgentCallable {
    var base  : String { get }
    var scheme: String { get }
}
