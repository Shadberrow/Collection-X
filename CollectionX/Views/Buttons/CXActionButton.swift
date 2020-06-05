//
//  CXActionButton.swift
//  CollectionX
//
//  Created by Yevhenii on 12.05.2020.
//  Copyright © 2020 Yevhenii. All rights reserved.
//

import UIKit

class CXActionButton: UIButton {

    enum State { case active, disabled }

    private let firstAnimationDuration: Double = 0//0.25
    private let secondAnimationDuration: Double = 0//0.1

    private      var isDisabled  : Bool    { actionState == .disabled }
    private(set) var actionState : State   = .disabled { didSet { updateUI() } }
    private      var actionColor : UIColor = .label

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    convenience init(title: String, color: UIColor, state: CXActionButton.State = .disabled) {
        self.init(type: .system)
        self.setTitle(title, for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        defer {
            self.actionColor = color
            self.actionState = state
        }
    }

    private func setupView() {
        setTitleColor(.white, for: .normal)
        layer.cornerRadius      = 10
    }

    private func updateUI() {
        UIView.animate(withDuration: firstAnimationDuration, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {
            self.transform = CGAffineTransform(scaleX: 0.92, y: 0.92)
        })

        UIView.animate(withDuration: secondAnimationDuration, delay: firstAnimationDuration, usingSpringWithDamping: 0.4, initialSpringVelocity: 2, options: .curveEaseIn, animations: {
            self.transform = CGAffineTransform.identity
        }, completion: nil)

        DispatchQueue.main.asyncAfter(deadline: .now() + firstAnimationDuration) { [weak self] in
            guard let self = self else { return }
            self.layer.borderColor = self.isDisabled ? self.actionColor.cgColor : UIColor.clear.cgColor
            self.layer.borderWidth = self.isDisabled ? 1 : 0

            self.backgroundColor = self.isDisabled ? .clear : self.actionColor
            self.setTitleColor(self.isDisabled ? .label : .secondarySystemBackground, for: .normal)
        }
    }

    func set(actionState: State) {
        self.actionState = actionState
    }

}
