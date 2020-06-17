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
    private let secondAnimationDuration: Double = 0.1

    private      var isDisabled  : Bool    { actionState == .disabled }
    private(set) var actionState : State   = .disabled { didSet { updateUI() } }
    private      var actionColor : UIColor = .label
    private      var titles      : (enabled: String, disabled: String) = Text.empty

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    convenience init(titles: (String, String), color: UIColor, state: CXActionButton.State = .disabled) {
        self.init(type: .system)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 11, weight: .semibold)
        defer {
            self.actionColor = color
            self.actionState = state
            self.titles = titles
        }
    }

    private func setupView() {
        setTitleColor(.white, for: .normal)
        layer.cornerRadius = 8
    }

    private func updateUI() {
        DispatchQueue.main.asyncAfter(deadline: .now() + firstAnimationDuration) { [weak self] in
            guard let self = self else { return }
            self.layer.borderColor = self.isDisabled ? self.actionColor.cgColor : UIColor.clear.cgColor
            self.layer.borderWidth = self.isDisabled ? 1 : 0

            self.backgroundColor = self.isDisabled ? .clear : self.actionColor
            self.setTitleColor(self.isDisabled ? .label : .secondarySystemBackground, for: .normal)
        }

        UIView.setAnimationsEnabled(false)
        self.setTitle(self.isDisabled ? self.titles.disabled.uppercased() : self.titles.enabled.uppercased(), for: .normal)
        UIView.setAnimationsEnabled(true)
    }

    func set(actionState: State) {
        self.actionState = actionState
    }

}
