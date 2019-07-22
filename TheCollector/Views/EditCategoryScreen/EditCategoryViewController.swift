//
//  EditCategoryViewController.swift
//  TheCollector
//
//  Created by Michael Holt on 7/22/19.
//  Copyright © 2019 Michael Holt. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

class EditCategoryViewController: UIViewController {
    let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: nil)
    let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: nil)

    var viewModel: EditCategoryViewModel!

    let contentView = EditCategoryView()

    override func loadView() {
        super.loadView()
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if viewModel == nil {
            fatalError("Set the ViewModel before allowing the ViewController to be displayed")
        }

        title = "Category"

        navigationItem.rightBarButtonItem = doneButton
        navigationItem.leftBarButtonItem = cancelButton

        bindToViewModel()
    }

    private func bindToViewModel() {
        doneButton.reactive.pressed = CocoaAction(viewModel.saveAction)
        doneButton.reactive.isEnabled <~ viewModel.saveAction.isEnabled
        cancelButton.reactive.pressed = CocoaAction(viewModel.cancelAction)
        contentView.mainTextField.reactive.text <~ viewModel.name
        viewModel.name <~ contentView.mainTextField.reactive.continuousTextValues.skipRepeats()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        contentView.mainTextField.becomeFirstResponder()
        contentView.mainTextField.delegate = self
    }
}

extension EditCategoryViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        viewModel.saveAction.apply().start()
        return true
    }
}
