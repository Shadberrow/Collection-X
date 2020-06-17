//
//  UIFont+.swift
//  CollectionX
//
//  Created by Yevhenii on 09.06.2020.
//  Copyright © 2020 Yevhenii. All rights reserved.
//

import UIKit


extension UIFont {

    static func preferredFont(forTextStyle style: UIFont.TextStyle, withTrait trait: UIFontDescriptor.SymbolicTraits.Element) -> UIFont {
        var symbolicTraits = UIFont.preferredFont(forTextStyle: style).fontDescriptor.symbolicTraits
        symbolicTraits.insert(trait)
        guard let fontDescriptor = UIFont.preferredFont(forTextStyle: style).fontDescriptor.withSymbolicTraits(symbolicTraits) else {
            return UIFont.preferredFont(forTextStyle: style)
        }
        return UIFont(descriptor: fontDescriptor, size: 0)
    }

}
