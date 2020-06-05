//
//  ReusableCell.swift
//  CollectionX
//
//  Created by Yevhenii on 12.05.2020.
//  Copyright © 2020 Yevhenii. All rights reserved.
//

import UIKit

protocol ReusableCell: class {
    static var reuseIdentifier: String { get }
}

extension UITableViewCell: ReusableCell {
    static var reuseIdentifier: String { String(describing: self) }
}

extension UICollectionViewCell: ReusableCell {
    static var reuseIdentifier: String { String(describing: self) }
}
