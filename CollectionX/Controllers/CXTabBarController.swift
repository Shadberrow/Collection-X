//
//  CXTabBarController.swift
//  CollectionX
//
//  Created by Yevhenii on 11.05.2020.
//  Copyright © 2020 Yevhenii. All rights reserved.
//

import UIKit

class CXTabBarController: UITabBarController {

    private var searchNavController    : UINavigationController!
    private var libraryNavController   : UINavigationController!

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    private func setup() {
//        searchNavController     = createTabController(controller: SearchViewController(),
//                                                      title: "Search",
//                                                      icon: SFSymbols.magnifyingGlass,
//                                                      tag: 2)
        searchNavController     = createTabController(controller: Scene.search(SearchViewModel()).viewController(),
        title: "Search",
        icon: SFSymbols.magnifyingGlass,
        tag: 2)
        libraryNavController  = createTabController(controller: LibraryViewController(),
                                                      title: "Library",
                                                      icon: SFSymbols.cards,
                                                      tag: 3)

        viewControllers = [
            searchNavController,
            libraryNavController
        ]

        selectedIndex = 0
    }

    private func createTabController<T: UIViewController>(controller: T, title: String?, icon: UIImage?, tag: Int) -> UINavigationController {
        controller.title = title
        controller.tabBarItem = UITabBarItem(title: title, image: icon, tag: tag)
        return UINavigationController(rootViewController: controller)
    }

}
