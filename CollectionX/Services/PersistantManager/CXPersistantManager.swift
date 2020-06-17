//
//  CXPersistantManager.swift
//  CollectionX
//
//  Created by Yevhenii on 25.05.2020.
//  Copyright © 2020 Yevhenii. All rights reserved.
//

import Foundation

//enum CXPersistantManager {
//
//    static private let defaults = UserDefaults.standard
//
//    enum Keys {
//        static let allItems = "all_items"
//        static let allStatuses = "all_statuses"
//    }
//
//    enum Error: String, Swift.Error {
//        case unableToFavorite   = "There was an error favoriting this user. Please try again."
//        case alreadyInFavorites = "You've alredy favorited this user."
//        case failedToUpdate     = "Item you want to update doesn't exist."
//
//        case unableToSave       = "There was an error saving this item. Please try again."
//        case decodeError        = "Failed to decode data to item object."
//        case encodeError        = "Failed to encode item object to data."
//        case noSuchItemForId    = "No item was found with such imdbID"
//        case noDataFound        = "No data found."
//    }
//
//    static func clearAllItems() {
//        defaults.set(nil, forKey: Keys.allItems)
//        defaults.set(nil, forKey: Keys.allStatuses)
//    }
//
//    static func getAll(_ forStatus: ItemStatusType, then: @escaping ([OMDBItemFullInfo]) -> Void) {
//        let allItems: [OMDBItemFullInfo] = getAll(forKey: Keys.allItems)
//        var allStatuses: [OMDBItemStatus] = getAll(forKey: Keys.allStatuses)
//        allStatuses = allStatuses.filter({ status in
//            switch forStatus {
//            case .favorited : return status.isFavorited
//            case .bookmarked: return status.isBookmarked
//            case .checkedIn : return status.isCheckedIn
//            }
//        })
//        let filtered = allItems.filter { item in allStatuses.contains(where: { $0.imdbID == item.imdbID }) }
//        then(filtered)
//    }
//
//    static func get(itemID: String) -> OMDBItemFullInfo? {
//        let array: [OMDBItemFullInfo] = getAll(forKey: Keys.allItems)
//        return array.first(where: { $0.imdbID == itemID })
//    }
//
//    static func status(forItem itemID: String) -> OMDBItemStatus? {
//        let array: [OMDBItemStatus] = getAll(forKey: Keys.allStatuses)
//        return array.first(where: { $0.imdbID == itemID })
//    }
//
//    static func update(item: OMDBItemFullInfo) {
//        saveItemInfo(item)
//    }
//
//    static func update(status: OMDBItemStatus) {
//        saveStatus(status)
//    }
//
//    static func set(status: ItemStatusType, forItem item: OMDBItemFullInfo, newState state: Bool, then: (() -> Void)? = nil) {
//        let allStatuses: [OMDBItemStatus] = getAll(forKey: Keys.allStatuses)
//        let oldStatus = allStatuses.first(where: { $0.imdbID == item.imdbID })
//
//        if state { saveItemInfo(item) }
//
//        if let oldStatus = oldStatus {
//            switch status {
//            case .favorited:
//                if !oldStatus.isCheckedIn && !oldStatus.isBookmarked {
//                    removeItemInfo(item)
//                    removeStatus(oldStatus)
//                    then?()
//                    return
//                }
//            case .bookmarked:
//                if !oldStatus.isCheckedIn && !oldStatus.isFavorited {
//                    removeItemInfo(item)
//                    removeStatus(oldStatus)
//                    then?()
//                    return
//                }
//            case .checkedIn:
//                if !oldStatus.isFavorited && !oldStatus.isBookmarked {
//                    removeItemInfo(item)
//                    removeStatus(oldStatus)
//                    then?()
//                    return
//                }
//            }
//        }
//
//        if var itemStatus = oldStatus {
//            itemStatus.set(value: state, forStatus: status)
//            saveStatus(itemStatus)
//        } else if state {
//            var itemStatus = OMDBItemStatus(id: item.imdbID)
//            itemStatus.set(value: state, forStatus: status)
//            saveStatus(itemStatus)
//        }
//
//        then?()
//    }
//
//// -----------
//
//    private static func saveItemInfo(_ info: OMDBItemFullInfo) {
//        var items: [OMDBItemFullInfo] = getAll(forKey: Keys.allItems)
//        items.removeAll(where: { $0.imdbID == info.imdbID })
//        items.append(info)
//        saveAll(items, forKey: Keys.allItems)
//    }
//
//    private static func removeItemInfo(_ info: OMDBItemFullInfo) {
//        var items: [OMDBItemFullInfo] = getAll(forKey: Keys.allItems)
//        items.removeAll(where: { $0.imdbID == info.imdbID })
//        saveAll(items, forKey: Keys.allItems)
//    }
//
//    private static func saveStatus(_ newStatus: OMDBItemStatus) {
//        var statuses: [OMDBItemStatus] = getAll(forKey: Keys.allStatuses)
//        statuses.removeAll(where: { $0.imdbID == newStatus.imdbID })
//        statuses.append(newStatus)
//        saveAll(statuses, forKey: Keys.allStatuses)
//    }
//
//    private static func removeStatus(_ status: OMDBItemStatus) {
//        var items: [OMDBItemStatus] = getAll(forKey: Keys.allStatuses)
//        items.removeAll(where: { $0.imdbID == status.imdbID })
//        saveAll(items, forKey: Keys.allStatuses)
//    }
//
//
//    private static func getAll<D: Decodable>(forKey key: String) -> [D] {
//        guard let data = defaults.data(forKey: key) else { return [] }
//        do {
//            return try JSONDecoder().decode([D].self, from: data)
//        } catch { print(error); return [] }
//    }
//
//    private static func saveAll<D: Encodable>(_ data: D, forKey key: String) {
//        do {
//            let data = try JSONEncoder().encode(data)
//            defaults.set(data, forKey: key)
//        } catch { print(error) }
//    }
//
//}
