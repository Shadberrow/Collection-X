//
//  CXTabBarController.swift
//  CollectionX
//
//  Created by Yevhenii on 11.05.2020.
//  Copyright © 2020 Yevhenii. All rights reserved.
//

import UIKit

class CXTabBarController: UITabBarController {

    private var archiveNavController   : UINavigationController!
    private var bookmarkNavController  : UINavigationController!
    private var searchNavController    : UINavigationController!
    private var favoritesNavController : UINavigationController!
    private var settingsNavController  : UINavigationController!

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    private func setup() {
        archiveNavController    = createTabController(controller: ArchiveViewController(),
                                                      title: "Archive",
                                                      icon: SFSymbols.archiveBoxFill,
                                                      tag: 0)
        bookmarkNavController   = createTabController(controller: BookmarkViewController(),
                                                      title: "To Watch",
                                                      icon: SFSymbols.bookmarkFill,
                                                      tag: 1)
        searchNavController     = createTabController(controller: SearchViewController(),
                                                      title: "Search",
                                                      icon: SFSymbols.magnifyingGlass,
                                                      tag: 2)
        favoritesNavController  = createTabController(controller: FavoritesViewController(),
                                                      title: "Favorites",
                                                      icon: SFSymbols.starFill,
                                                      tag: 3)
        settingsNavController   = createTabController(controller: SettingsViewController(),
                                                      title: "Settings",
                                                      icon: SFSymbols.gear,
                                                      tag: 4)

        viewControllers = [
            archiveNavController,
            bookmarkNavController,
            searchNavController,
            favoritesNavController,
            settingsNavController
        ]

        selectedIndex = 3
    }

    private func createTabController<T: UIViewController>(controller: T, title: String?, icon: UIImage?, tag: Int) -> UINavigationController {
        controller.title = title
        controller.tabBarItem = UITabBarItem(title: title, image: icon, tag: tag)
        return UINavigationController(rootViewController: controller)
    }

}
