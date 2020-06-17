//
//  Bindable.swift
//  CollectionX
//
//  Created by Yevhenii on 17.06.2020.
//  Copyright © 2020 Yevhenii. All rights reserved.
//

import UIKit

protocol Bindable {

    associatedtype ViewModel

    var viewModel: ViewModel! { get set }

    func bindViewModel()

}


extension Bindable where Self: UIViewController {

    mutating func bind(viewModel: ViewModel) {
        self.viewModel = viewModel
        self.loadViewIfNeeded()
        self.bindViewModel()
    }

}
