//
//  CXDataManager.swift
//  CollectionX
//
//  Created by Yevhenii on 15.06.2020.
//  Copyright © 2020 Yevhenii. All rights reserved.
//

import Foundation


struct ItemInfo: Codable, Hashable {

    static let empty = ItemInfo(title       : "", year      : "",
                                released    : "", runtime   : "",
                                genre       : "", actors    : "",
                                posterUrl   : "", rated     : "",
                                imdbRating  : "", imdbVotes : "",
                                imdbID      : "", type      : "",
                                plot        : "", director  : "", writer: "")

    enum CodingKeys: String, CodingKey {
        case title       = "Title"
        case year        = "Year"
        case released    = "Released"
        case runtime     = "Runtime"
        case genre       = "Genre"
        case actors      = "Actors"
        case posterUrl   = "Poster"
        case rated       = "Rated"
        case imdbRating  = "imdbRating"
        case imdbVotes   = "imdbVotes"
        case imdbID      = "imdbID"
        case type        = "Type"
        case plot        = "Plot"
        case director    = "Director"
        case writer      = "Writer"
    }

    let title       : String
    let year        : String
    let released    : String
    let runtime     : String
    let genre       : String
    let actors      : String
    let posterUrl   : String
    let rated       : String
    let imdbRating  : String
    let imdbVotes   : String
    let imdbID      : String
    let type        : String
    let plot        : String
    let director    : String
    let writer      : String

}

extension ItemInfo {
    var prettyYear: String {
           return year.last?.isNumber ?? false ? year : year + "?"
       }

       var prettyRuntime: String {
           let minutesString = runtime.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
           guard let minutesInt = Int(minutesString) else { return "?m" }
           let minutes = minutesInt % 60
           let hours = minutesInt / 60

           return minutesInt == 60 ? "\(minutesInt)m" : (minutesInt < 60 ? "\(minutes)m" : "\(hours)h \(minutes)m")
       }

       var prettySubinfo: String {
           return "\(prettyYear)   \(rated)   \(prettyRuntime)   \(type.prefix(1).capitalized + type.dropFirst())"
       }
}

enum Status {
    case favorited
    case bookmarked
    case checkedIn
}

enum StatusValue {
    case favorited(_ status: Bool? = nil)
    case bookmarked(_ status: Bool? = nil)
    case checkedIn(_ status: Bool? = nil)
}

struct ItemStatus: Codable, Hashable {

    var isFavorited      = false
    var isBookmarked     = false
    var isCheckedIn      = false
    var userRating: Int? = nil

}


struct Item: Codable, Hashable {

    var info: ItemInfo = .empty
    var status = ItemStatus()
    var id: String

    init() {
        id = info.imdbID
    }

    init(_ item: ItemInfo) {
        info = item
        id = info.imdbID
    }

    mutating func set(_ status: StatusValue) {
        switch status {
        case let .favorited(s)  : self.status.isFavorited  = s ?? false
        case let .bookmarked(s) : self.status.isBookmarked = s ?? false
        case let .checkedIn(s)  : self.status.isCheckedIn  = s ?? false
        }
    }

    mutating func set(_ rating: Int) {
        status.userRating = rating
    }

}


extension UserDefaults {
    enum UserKey {
        static let allItems = "allItems"
    }
}

enum CXDataManager {

    static private let defaults = UserDefaults.standard

    enum Error: String, Swift.Error {
        case unableToSave       = "There was an error saving this item. Please try again."
        case decodeError        = "Failed to decode data to item object."
        case encodeError        = "Failed to encode item object to data."
        case noSuchData         = "No data related to the key has been found."
    }


    static func save<T: Encodable>(_ items: [T], key: String) throws {
        try defaults.set(items.encoded(), forKey: key)
    }

    static func get<T: Decodable>(forKey key: String) throws -> [T] {
        guard let data = defaults.data(forKey: key) else { return [] }
        return try data.decoded()
    }

}


extension CXDataManager {

    static func clearAll() {
        defaults.set(nil, forKey: UserDefaults.UserKey.allItems)
    }

    static func set(status: StatusValue, forItem item: ItemInfo) throws {
        var allItems: [Item] = try get(forKey: UserDefaults.UserKey.allItems)
        guard var oldItem = allItems.first(where: { $0.id == item.imdbID }) else {
            return try update(items: &allItems, forValue: createNewRecord(for: item, with: status))
        }

        oldItem.set(status)
        try update(items: &allItems, forValue: oldItem)
    }

    static func set(rating: Int, forItem item: ItemInfo) throws {
        var allItems: [Item] = try get(forKey: UserDefaults.UserKey.allItems)
        guard var oldItem = allItems.first(where: { $0.id == item.imdbID }) else { return }

        oldItem.set(rating)
        try update(items: &allItems, forValue: oldItem)
    }

    static func getItem(forID id: String) throws -> Item? {
        let allItems: [Item] = try get(forKey: UserDefaults.UserKey.allItems)
        return allItems.first(where: { $0.id == id })
    }

    static func removeItem(forID id: String) throws {
        var allItems: [Item] = try get(forKey: UserDefaults.UserKey.allItems)
        guard let removeItem = try getItem(forID: id) else { return }
        allItems.removeAll(where: { $0.id == removeItem.id })
        try save(allItems, key: UserDefaults.UserKey.allItems)
    }

    static func getItems(for status: Status) throws -> [Item] {
        return try get(forKey: UserDefaults.UserKey.allItems).filter({ item in
            switch status {
            case .favorited: return item.status.isFavorited
            case .bookmarked: return item.status.isBookmarked
            case .checkedIn: return item.status.isCheckedIn
            }
        })
    }

    private static func update(items: inout [Item], forValue value: Item) throws {
        items.removeAll(where: { $0.id == value.id })
        items.append(value)
        try save(items, key: UserDefaults.UserKey.allItems)
    }

    private static func createNewRecord(for item: ItemInfo, with status: StatusValue) -> Item {
        var newItem = Item(item)
        newItem.set(status)
        return newItem
    }

}



















protocol AnyDecoder {
    func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T
}

extension JSONDecoder: AnyDecoder {}
extension PropertyListDecoder: AnyDecoder {}

extension Data {
    func decoded<T: Decodable>(using decoder: AnyDecoder = JSONDecoder()) throws -> T {
        return try decoder.decode(T.self, from: self)
    }
}

/*

  Here we're using the default way to decode a set of data into a User instance,
  which we then pass to a function to let our login system know that a user has
  logged in:

  let decoder = JSONDecoder()
  let user = try decoder.decode(User.self, from: data)
  userDidLogin(user)

  Now with type inference we can reduce out three lines of decoding code from before
  to a single line that passes any decoded value directly into the userDidLogin
  function - and since that accepts a User that's what the type system will use
  whed decoding:

  try userDidLogin(data.decoded())

  Sweet!

*/




protocol AnyEncoder {
    func encode<T: Encodable>(_ value: T) throws -> Data
}

extension JSONEncoder: AnyEncoder {}
extension PropertyListEncoder: AnyEncoder {}

extension Encodable {
    func encoded(using encoder: AnyEncoder = JSONEncoder()) throws -> Data {
        return try encoder.encode(self)
    }
}

/*

  let data = try user.encoded()

*/








extension KeyedDecodingContainerProtocol {
    func decode<T: Decodable>(forKey key: Key) throws -> T {
        return try decode(T.self, forKey: key)
    }

    func decode<T: Decodable>(forKey key: Key, default defaultExpression: @autoclosure () -> T) throws -> T {
        return try decodeIfPresent(T.self, forKey: key) ?? defaultExpression()
    }
}

/*

  struct Video {
    let url: URL
    let containsAds: Bool
    var comments: [Comment]
  }

  extension Video: Decodable {
    enum CodingKey: String, Swift.CodingKey {
      case url
      case containsAds = "contains_ads"
      case comments
    }

    init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKey.self)
      url = try container.decode(URL.self, forKey: .url)
      containsAds = try container.decodeIfPresent(Bool.self, forKey: .containsAds) ?? false
      comments = try container.decodeIfPresent([Comment].self, forKey: .comments) ?? []
    }
  }

  Update:

  extension Video: Decodable {
    enum CodingKey: String, Swift.CodingKey {
      case url
      case containsAds = "contains_ads"
      case comments
    }

    init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKey.self)
      url = try container.decode(forKey: .url)
      containsAds = try container.decode(forKey: .containsAds, default: false)
      comments = try container.decode(forKey: .comments, default: [])
    }
  }

*/
