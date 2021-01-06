//
//  SearchViewModel.swift
//  CollectionX
//
//  Created by Yevhenii Veretennikov on 07.11.2020.
//  Copyright © 2020 Yevhenii. All rights reserved.
//

import Foundation
import Combine

protocol SearchViewModelProtocol {
    var dataPublisher: PassthroughSubject<[APISearchItem], Never> { get }
    
    func search(key: String)
    func searchNextPage()
}

class SearchViewModel: SearchViewModelProtocol {
    
    private let dataStore: RemoteDataStore
    
    private var page = Int()
    private var total = Int()
    private var searchKey = String()
    
    var dataPublisher = PassthroughSubject<[APISearchItem], Never>()
    
    init(dataStore: RemoteDataStore) {
        self.dataStore = dataStore
    }
    
    func search(key: String) {
        if key.compare(searchKey) != .orderedSame {
            page = 1
        }
        searchKey = key
        performRequest(for: searchKey, page: page)
    }
    
    func searchNextPage() {
        performRequest(for: searchKey, page: page)
    }
    
    private func performRequest(for key: String, page: Int) {
        if key.isEmpty { return }
        
        dataStore.search(for: key, page: page) { [weak self] result in
            self?.process(result)
        }
    }
    
    private func process(_ result: Result<APISearchResult, Error>) {
        switch result {
        case .failure(let error):
            self.dataPublisher.send([])
            print(error)
        case .success(let data):
            self.total = data.metadata.total
            self.dataPublisher.send(data.items)
            self.page += data.items.count == 0 ? 0 : 1
        }
    }
    
}
