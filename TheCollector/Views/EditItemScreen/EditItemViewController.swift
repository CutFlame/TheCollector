//
//  EditItemViewController.swift
//  TheCollector
//
//  Created by Michael Holt on 7/24/19.
//  Copyright © 2019 Michael Holt. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

class EditItemViewController: UIViewController {
    let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: nil)
    let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: nil)

    var viewModel: EditItemViewModel!

    let contentView = EditItemView()

    override func loadView() {
        super.loadView()
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if viewModel == nil {
            fatalError("Set the ViewModel before allowing the ViewController to be displayed")
        }

        title = "Item"

        navigationItem.rightBarButtonItem = doneButton
        navigationItem.leftBarButtonItem = cancelButton

        bindToViewModel()
    }

    private func bindToViewModel() {
        doneButton.reactive.pressed = CocoaAction(viewModel.saveAction)
        doneButton.reactive.isEnabled <~ viewModel.saveAction.isEnabled
        cancelButton.reactive.pressed = CocoaAction(viewModel.cancelAction)

        contentView.titleTextField.reactive.text <~ viewModel.title
        viewModel.title <~ contentView.titleTextField.reactive.continuousTextValues.skipRepeats()
        contentView.descriptionTextView.reactive.text <~ viewModel.description
        viewModel.description <~ contentView.descriptionTextView.reactive.continuousTextValues.skipRepeats()
        contentView.ratingSlider.reactive.value <~ viewModel.rating.map(Float.init)
        viewModel.rating <~ contentView.ratingSlider.reactive.controlEvents(.touchUpInside)
            .map(\UISlider.value).map({ $0.rounded() }).map(UInt8.init)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        contentView.titleTextField.becomeFirstResponder()
        contentView.titleTextField.delegate = self
    }
}

extension EditItemViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}
