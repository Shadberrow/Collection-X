//
//  CXCloseButton.swift
//  CollectionX
//
//  Created by Yevhenii on 03.06.2020.
//  Copyright © 2020 Yevhenii. All rights reserved.
//

import UIKit
import YVAnchor

class CXCloseButton: UIButton {

    private var closeImage: UIImageView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    convenience init(systemImage: UIImage? = SFSymbols.xMark) {
        self.init(frame: .zero)
    }

    private func setupView() {
        closeImage = UIImageView(image: SFSymbols.xMark)
        closeImage.tintColor = .label

        addSubview(closeImage)

        closeImage.fill(in: self, constants: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
    }

}
