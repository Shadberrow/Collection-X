//
//  KeyPathSetter.swift
//  CollectionX
//
//  Created by Yevhenii on 07.06.2020.
//  Copyright © 2020 Yevhenii. All rights reserved.
//

import Foundation

func setter<O: AnyObject, V>(for object: O, _ keyPath: ReferenceWritableKeyPath<O, V>) -> (V) -> Void {
    { [weak object] value in
        object?[keyPath: keyPath] = value
    }
}
