//
//  HelperUI.swift
//  CollectionX
//
//  Created by Yevhenii on 17.06.2020.
//  Copyright © 2020 Yevhenii. All rights reserved.
//

import UIKit

enum CollecitonLayout {

    static func createThreeItemLayout(forFrame frame: CGRect) -> UICollectionViewFlowLayout {
        let padding: CGFloat                = 12
        let minimumItemSpacing: CGFloat     = 10
        let availableWidth                  = frame.width - (padding * 2) - (minimumItemSpacing * 1)
        let itemWidth                       = availableWidth / 2

        let collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        collectionLayout.itemSize = CGSize(width: itemWidth, height: 4/3 * itemWidth)

        return collectionLayout
    }

}
