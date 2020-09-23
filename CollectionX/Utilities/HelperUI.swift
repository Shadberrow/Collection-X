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

    static func makeCollectionViewLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.5))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)
        group.interItemSpacing = NSCollectionLayoutSpacing.fixed(10)


        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)

        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }

}
