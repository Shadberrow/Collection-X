 //
//  RemoteDataStore.swift
//  CollectionX
//
//  Created by Yevhenii Veretennikov on 09.11.2020.
//  Copyright © 2020 Yevhenii. All rights reserved.
//

import Foundation

enum RemoteDataStoreError: Error {
    case badUrl
    case urlSessionError
    case noData
    case dataDecoding
}

protocol RemoteDataStore {
    func search(for key: String, page: Int, with block: @escaping (Result<APISearchResult, Error>) -> Void)
}

class TMDRemoteDataStore: NSObject, RemoteDataStore, URLSessionDataDelegate {
    
    var workItem: DispatchWorkItem?
    var isLoading: Bool = false
    
    func search(for key: String, page: Int, with block: @escaping (Result<APISearchResult, Error>) -> Void) {
        if self.isLoading { return }
        
        self.workItem?.cancel()
        let workItem = DispatchWorkItem { [weak self] in
            self?.performSearch(for: key, page: page, with: block)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: workItem)
        self.workItem = workItem
    }
    
    private func performSearch(for key: String, page: Int, with block: @escaping (Result<APISearchResult, Error>) -> Void) {
        guard let url = Endpoint.matching(query: key, page: page).url else {
            return block(.failure(RemoteDataStoreError.badUrl)) }
        
        runDataTask(url) { [weak self] result in
            switch result {
            case .failure(let error): block(.failure(error))
            case .success(let data):
                guard let tmd = try? self?.handleResponseData(APISearchResult.self, from: data) else {
                    return block(.failure(RemoteDataStoreError.dataDecoding)) }
                
                block(.success(tmd))
            }
        }
    }
    
    private func runDataTask(_ url: URL, with block: @escaping (Result<Data, Error>) -> Void) {
        print(url.absoluteString)
        self.isLoading = true
        URLSession.shared.dataTask(with: url) { data, response, error in
            self.isLoading = false
            
            guard error == nil else {
                return block(.failure(RemoteDataStoreError.urlSessionError)) }
            
            guard let data = data else {
                return block(.failure(RemoteDataStoreError.noData)) }
            
            block(.success(data))
        }.resume()
    }
    
    private func handleResponseData<T>(_ type: T.Type, from data: Data, decoder: JSONDecoder = JSONDecoder()) throws -> T where T : Decodable {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(type, from: data)
    }
    
}
