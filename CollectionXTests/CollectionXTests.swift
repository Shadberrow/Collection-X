//
//  CollectionXTests.swift
//  CollectionXTests
//
//  Created by Yevhenii on 27.05.2020.
//  Copyright © 2020 Yevhenii. All rights reserved.
//

import XCTest
@testable import CollectionX

class CollectionXTests: XCTestCase {

    let movie1 = OMDBItemFullInfo(title      : "The Avengers",
                                 year       : "2004",
                                 released   : "2004",
                                 runtime    : "120",
                                 genre      : "genre",
                                 actors     : "Some puls and guls",
                                 posterUrl  : "https://img.jpg",
                                 rated      : "1",
                                 imdbRating : "7.6",
                                 imdbVotes  : "12,321",
                                 imdbID     : "tt00010",
                                 type       : "movie")

    let movie2 = OMDBItemFullInfo(title      : "The Avengers 2",
                                  year       : "2008",
                                  released   : "2008",
                                  runtime    : "130",
                                  genre      : "genre",
                                  actors     : "Some puls and guls",
                                  posterUrl  : "https://img.jpg",
                                  rated      : "1",
                                  imdbRating : "7.6",
                                  imdbVotes  : "12,321",
                                  imdbID     : "tt00011",
                                  type       : "movie")

    override class func tearDown() {
        CXPersistantManager.clearAllItems()
    }

    func testPersistantManager_updateStatus_False() {
        CXPersistantManager.clearAllItems()

        CXPersistantManager.set(status: .favorited, forItem: movie1, newState: false) { _ in print("Done") }
        CXPersistantManager.getAll(.favorited) { XCTAssert($0 == []) }
    }

    func testPersistantManager_updateStatus_True_then_False() {
        CXPersistantManager.clearAllItems()

        CXPersistantManager.set(status: .favorited, forItem: movie1, newState: true)

        CXPersistantManager.getAll(.favorited) { XCTAssert($0 == [self.movie1]) }

        CXPersistantManager.set(status: .favorited, forItem: movie1, newState: false)

        CXPersistantManager.getAll(.favorited) { XCTAssert($0 == []) }
    }

    func testPersistantManager_updateBookmarkStatus_False() {
        CXPersistantManager.clearAllItems()

        CXPersistantManager.set(status: .bookmarked, forItem: movie1, newState: false)

        CXPersistantManager.getAll(.bookmarked) { XCTAssert($0 == []) }
    }

    func testPersistantManager_updateBookmarkStatus_True_then_False() {
        CXPersistantManager.clearAllItems()

        CXPersistantManager.set(status: .bookmarked, forItem: movie1, newState: true)
        CXPersistantManager.set(status: .bookmarked, forItem: movie2, newState: true)
        CXPersistantManager.set(status: .favorited, forItem: movie2, newState: true)

        CXPersistantManager.getAll(.favorited) { XCTAssert($0 == [self.movie2]) }
        CXPersistantManager.getAll(.bookmarked) { XCTAssert($0 == [self.movie1, self.movie2]) }

        CXPersistantManager.set(status: .bookmarked, forItem: movie1, newState: false)

        CXPersistantManager.getAll(.favorited) { XCTAssert($0 == [self.movie2]) }
        CXPersistantManager.getAll(.bookmarked) { XCTAssert($0 == [self.movie2]) }

        CXPersistantManager.set(status: .favorited, forItem: movie2, newState: false)

        CXPersistantManager.getAll(.favorited) { XCTAssert($0 == []) }
        CXPersistantManager.getAll(.bookmarked) { XCTAssert($0 == [self.movie2]) }

        CXPersistantManager.set(status: .bookmarked, forItem: movie2, newState: false)

        CXPersistantManager.getAll(.favorited) { XCTAssert($0 == []) }
        CXPersistantManager.getAll(.bookmarked) { XCTAssert($0 == []) }
    }

    func testPersistantManager_saveFavorite_andCheck() {
        CXPersistantManager.clearAllItems()

        CXPersistantManager.set(status: .favorited, forItem: movie1, newState: true)

        XCTAssert(CXPersistantManager.get(itemID: movie1.imdbID) == movie1)
        XCTAssert(CXPersistantManager.status(forItem: movie1.imdbID)?.isFavorited == true)
        XCTAssert(CXPersistantManager.status(forItem: movie1.imdbID)?.isBookmarked == false)
        XCTAssert(CXPersistantManager.status(forItem: movie1.imdbID)?.isCheckedIn == false)
    }

}
