//
//  CXPersistantManager.swift
//  CollectionX
//
//  Created by Yevhenii on 25.05.2020.
//  Copyright © 2020 Yevhenii. All rights reserved.
//

import Foundation

enum CXPersistantManager {

    static private let defaults = UserDefaults.standard

    enum Keys {
        static let allItems = "all_items"
        static let allStatuses = "all_statuses"
    }

    enum Error: String, Swift.Error {
        case unableToFavorite   = "There was an error favoriting this user. Please try again."
        case alreadyInFavorites = "You've alredy favorited this user."
        case failedToUpdate     = "Item you want to update doesn't exist."

        case unableToSave       = "There was an error saving this item. Please try again."
        case decodeError        = "Failed to decode data to item object."
        case encodeError        = "Failed to encode item object to data."
        case noSuchItemForId    = "No item was found with such imdbID"
        case noDataFound        = "No data found."
    }

    static func clearAllItems() {
        defaults.set(nil, forKey: Keys.allItems)
        defaults.set(nil, forKey: Keys.allStatuses)
    }

    static func getAll(_ forStatus: ItemStatusType, completion: @escaping ([OMDBItemFullInfo]) -> Void) {
        let allItems = retreiveAllItems()
        let allStatuses = retreiveAllStatuses().filter({ status in
            switch forStatus {
            case .favorited : return status.isFavorited
            case .bookmarked: return status.isBookmarked
            case .checkedIn : return status.isCheckedIn
            }
        })
        let filtered = allItems.filter { item in allStatuses.contains(where: { $0.imdbID == item.imdbID }) }
        completion(filtered)
    }

    static func get(itemID: String) -> OMDBItemFullInfo? {
        let allItems = retreiveAllItems()
        return allItems.first(where: { $0.imdbID == itemID })
    }

    static func status(forItem itemID: String) -> OMDBItemStatus? {
        return retreiveAllStatuses().first(where: { $0.imdbID == itemID })
    }

    static func set(status: ItemStatusType, forItem item: OMDBItemFullInfo, newState state: Bool, completion: (() -> Void)? = nil) {
        let oldStatus = retreiveAllStatuses().first(where: { $0.imdbID == item.imdbID })

        if state { saveItemInfo(item) }

        if let oldStatus = oldStatus {
            switch status {
            case .favorited:
                if !oldStatus.isCheckedIn && !oldStatus.isBookmarked {
                    removeItemInfo(item)
                    removeStatus(oldStatus)
                    completion?()
                    return
                }
            case .bookmarked:
                if !oldStatus.isCheckedIn && !oldStatus.isFavorited {
                    removeItemInfo(item)
                    removeStatus(oldStatus)
                    completion?()
                    return
                }
            case .checkedIn:
                if !oldStatus.isFavorited && !oldStatus.isBookmarked {
                    removeItemInfo(item)
                    removeStatus(oldStatus)
                    completion?()
                    return
                }
            }
        }

        if var itemStatus = oldStatus {
            itemStatus.set(value: state, forStatus: status)
            saveStatus(itemStatus)
        } else if state {
            var itemStatus = OMDBItemStatus(id: item.imdbID)
            itemStatus.set(value: state, forStatus: status)
            saveStatus(itemStatus)
        }

        completion?()
    }

// -----------

    private static func saveItemInfo(_ info: OMDBItemFullInfo) {
        var items = retreiveAllItems()
        if items.contains(where: { $0.imdbID == info.imdbID }) { return }
        items.append(info)
        saveAllItems(items)
    }

    private static func removeItemInfo(_ info: OMDBItemFullInfo) {
        var items = retreiveAllItems()
        items.removeAll(where: { $0.imdbID == info.imdbID })
        saveAllItems(items)
    }

    private static func retreiveAllItems() -> [OMDBItemFullInfo] {
        guard let data = defaults.data(forKey: Keys.allItems) else { return [] }
        do {
            return try JSONDecoder().decode([OMDBItemFullInfo].self, from: data)
        } catch { print(error); return [] }
    }

    private static func saveAllItems(_ items: [OMDBItemFullInfo]) {
        do {
            let data = try JSONEncoder().encode(items)
            defaults.set(data, forKey: Keys.allItems)
        } catch { print(error) }
    }



    private static func saveStatus(_ newStatus: OMDBItemStatus) {
        var statuses = retreiveAllStatuses()
        statuses.removeAll(where: { $0.imdbID == newStatus.imdbID })
        statuses.append(newStatus)
        saveAllStatuses(statuses)
    }

    private static func removeStatus(_ status: OMDBItemStatus) {
        var items = retreiveAllStatuses()
        items.removeAll(where: { $0.imdbID == status.imdbID })
        saveAllStatuses(items)
    }

    private static func retreiveAllStatuses() -> [OMDBItemStatus] {
        guard let data = defaults.data(forKey: Keys.allStatuses) else { return [] }
        do {
            return try JSONDecoder().decode([OMDBItemStatus].self, from: data)
        } catch { print(error); return [] }
    }

    private static func saveAllStatuses(_ items: [OMDBItemStatus]) {
        do {
            let data = try JSONEncoder().encode(items)
            defaults.set(data, forKey: Keys.allStatuses)
        } catch { print(error) }
    }

}
