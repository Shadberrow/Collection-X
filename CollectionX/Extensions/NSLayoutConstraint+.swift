//
//  NSLayoutConstraint+.swift
//  CollectionX
//
//  Created by Yevhenii on 03.06.2020.
//  Copyright © 2020 Yevhenii. All rights reserved.
//

import UIKit

extension NSLayoutConstraint {

    func deactivated() -> NSLayoutConstraint {
        self.isActive = false
        return self
    }

    func activated() -> NSLayoutConstraint {
        self.isActive = true
        return self
    }

}
