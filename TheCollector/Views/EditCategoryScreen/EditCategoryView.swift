//
//  EditCategoryView.swift
//  TheCollector
//
//  Created by Michael Holt on 7/22/19.
//  Copyright © 2019 Michael Holt. All rights reserved.
//

import UIKit

class EditCategoryView: UIView {
    let mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .left
        label.text = "Name"
        label.textColor = .black
        return label
    }()
    let mainTextField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.layer.borderColor = UIColor.black.cgColor
        field.layer.borderWidth = 1
        return field
    }()

    lazy private(set) var mainStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [mainLabel, mainTextField, UIView()])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fill
        stack.alignment = .fill
        stack.axis = .vertical
        stack.spacing = 16
        return stack
    }()

    init() {
        super.init(frame: CGRect.zero)
        self.backgroundColor = .white
        addSubview(mainStack)
        addConstraints([
            mainStack.topAnchor.constraint(equalToSystemSpacingBelow: self.safeAreaLayoutGuide.topAnchor, multiplier: 1),
            mainStack.leadingAnchor.constraint(equalToSystemSpacingAfter: self.safeAreaLayoutGuide.leadingAnchor, multiplier: 1),
            self.safeAreaLayoutGuide.trailingAnchor.constraint(equalToSystemSpacingAfter: mainStack.trailingAnchor, multiplier: 1),
            self.safeAreaLayoutGuide.bottomAnchor.constraint(equalToSystemSpacingBelow: mainStack.bottomAnchor, multiplier: 1),
            ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
