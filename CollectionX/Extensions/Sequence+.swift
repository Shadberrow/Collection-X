//
//  Sequence+.swift
//  CollectionX
//
//  Created by Yevhenii on 11.06.2020.
//  Copyright © 2020 Yevhenii. All rights reserved.
//

import Foundation

extension Sequence {
    func sorted<T: Comparable>(by keyPath: KeyPath<Element, T>) -> [Element] {
        sorted { a, b in
            a[keyPath: keyPath] < b[keyPath: keyPath]
        }
    }
}
