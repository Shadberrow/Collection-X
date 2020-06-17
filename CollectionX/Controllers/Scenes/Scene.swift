//
//  Scene.swift
//  CollectionX
//
//  Created by Yevhenii on 17.06.2020.
//  Copyright © 2020 Yevhenii. All rights reserved.
//

import UIKit

enum Scene {
    case search(SearchViewModel)
}

extension Scene {

    func viewController() -> UIViewController {
        switch self {
        case let .search(viewModel):
            var controller = SearchVC()
            controller.bind(viewModel: viewModel)
            return controller
        }
    }

}
