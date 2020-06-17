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

    let movie3 = ItemInfo(title    : "The Avengers 3",
                        year       : "2004",
                        released   : "2004",
                        runtime    : "120",
                        genre      : "genre",
                        actors     : "Some puls and guls",
                        posterUrl  : "https://img.jpg",
                        rated      : "1",
                        imdbRating : "7.6",
                        imdbVotes  : "12,321",
                        imdbID     : "tt00012",
                        type       : "movie", plot: "", director: "", writer: "")

    override class func tearDown() {
        CXDataManager.clearAll()
    }

    func testDataManager_saveMovieAndTweekStatus() {
        var savedItem: Item? = nil

        // Clear all items in UsedDefaults storage
        CXDataManager.clearAll()

        // Save a new movie item to a database with 'Bookmarked' status set to true
        // Fetch saved item from the database after it is saved
        do    { try CXDataManager.set(status: .bookmarked(true), forItem: movie3)
                try savedItem = CXDataManager.getItem(forID: movie3.imdbID) }
        catch { assertionFailure(error.localizedDescription) }

        // Check if item was saved successfully
        // Check if item statuses are set correctly
        XCTAssertTrue(savedItem != nil)
        XCTAssert(savedItem?.status.isBookmarked == true)
        XCTAssert(savedItem?.status.isFavorited == false)
        XCTAssert(savedItem?.status.isCheckedIn == false)

        // Update 'Favorite' status for the same movie to true
        // Fetch saved item from the database
        try? CXDataManager.set(status: .favorited(true), forItem: movie3)
        try? savedItem = CXDataManager.getItem(forID: movie3.imdbID)

        // Check if item statuses are set correctly
        XCTAssert(savedItem?.status.isBookmarked == true)
        XCTAssert(savedItem?.status.isFavorited == true)
        XCTAssert(savedItem?.status.isCheckedIn == false)

        // Update 'Bookmarked' status for the same movie to false
        // Fetch saved item from the database
        try? CXDataManager.set(status: .bookmarked(false), forItem: movie3)
        try? savedItem = CXDataManager.getItem(forID: movie3.imdbID)

        // Check if item statuses are set correctly
        XCTAssert(savedItem?.status.isBookmarked == false)
        XCTAssert(savedItem?.status.isFavorited == true)
        XCTAssert(savedItem?.status.isCheckedIn == false)

        // Remove movie from the database
        // Check if item still exist
        try? CXDataManager.removeItem(forID: movie3.imdbID)
        try? savedItem = CXDataManager.getItem(forID: movie3.imdbID)

        XCTAssertNil(savedItem)
        
    }

    func testDataManager_saveMovieToFavoriteAndGetAll() {
        var allItems: [Item]? = nil
        // Clear all items in UsedDefaults storage
        CXDataManager.clearAll()

        try? CXDataManager.set(status: .favorited(true), forItem: movie3)
        try? allItems = CXDataManager.getItems(for: .favorited)
        XCTAssertEqual(allItems?.map({ $0.info }), [movie3])
    }

    func testDataManager_saveMovieToBookmarksAndGetAll() {
        var allItems: [Item]? = nil
        // Clear all items in UsedDefaults storage
        CXDataManager.clearAll()

        try? CXDataManager.set(status: .bookmarked(true), forItem: movie3)
        try? allItems = CXDataManager.getItems(for: .bookmarked)
        XCTAssertEqual(allItems?.map({ $0.info }), [movie3])
    }

    func testDataManager_saveMovieToCheckInsAndGetAll() {
        var allItems: [Item]? = nil
        // Clear all items in UsedDefaults storage
        CXDataManager.clearAll()

        try? CXDataManager.set(status: .checkedIn(true), forItem: movie3)
        try? allItems = CXDataManager.getItems(for: .checkedIn)
        XCTAssertEqual(allItems?.map({ $0.info }), [movie3])
    }

}
