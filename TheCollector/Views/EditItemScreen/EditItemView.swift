//
//  EditItemView.swift
//  TheCollector
//
//  Created by Michael Holt on 7/24/19.
//  Copyright © 2019 Michael Holt. All rights reserved.
//

import UIKit

class EditItemView: UIView {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .left
        label.text = "Title"
        label.textColor = .black
        return label
    }()
    let titleTextField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.layer.borderColor = UIColor.gray.cgColor
        field.layer.borderWidth = 1
        return field
    }()
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .left
        label.text = "Description"
        label.textColor = .black
        return label
    }()
    let descriptionTextView: UITextView = {
        let field = UITextView()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.heightAnchor.constraint(equalToConstant: 150).isActive = true
        field.layer.borderColor = UIColor.gray.cgColor
        field.layer.borderWidth = 1
        return field
    }()
    let ratingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .left
        label.text = "Rating 1-5"
        label.textColor = .black
        return label
    }()
    let ratingSlider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumValue = 1
        slider.maximumValue = 5
        return slider
    }()

    lazy private(set) var mainStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            titleLabel,
            titleTextField,
            descriptionLabel,
            descriptionTextView,
            ratingLabel,
            ratingSlider,
            UIView()
            ])
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
