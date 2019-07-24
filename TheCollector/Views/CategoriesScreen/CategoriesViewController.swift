//
//  CategoriesViewController.swift
//  TheCollector
//
//  Created by Michael Holt on 7/22/19.
//  Copyright © 2019 Michael Holt. All rights reserved.
//

import ReactiveCocoa
import ReactiveSwift
import UIKit

class CategoriesViewController: UITableViewController {
    let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)

    var viewModel: CategoriesViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        if viewModel == nil {
            fatalError("Set the ViewModel before allowing the ViewController to be displayed")
        }

        title = "Categories"

        tableView.register(CategoryCell.self, forCellReuseIdentifier: "CategoryCell")
        navigationItem.rightBarButtonItem = addButton

        bindToViewModel()
    }

    private func bindToViewModel() {
        addButton.reactive.pressed = CocoaAction(viewModel.addCategoryAction)
        addButton.reactive.isEnabled <~ viewModel.addCategoryAction.isEnabled
        viewModel.fetchAction.values.observeValues { [weak self] in self?.tableView.reloadData() }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchAction.apply().start()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.categories.value.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let category = viewModel.categories.value[indexPath.row]
        cell.textLabel?.text = category.name
        cell.detailTextLabel?.text = "\(category.itemIDs.count) items"
        return cell
    }

    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let category = viewModel.categories.value[indexPath.row]
        let editAction = UIContextualAction(style: .normal, title: "Edit", handler: { [weak self] _, _, _ in
            self?.viewModel.editCategoryAction.apply(category).start()
        })
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete", handler: { [weak self] _, _, completion in
            self?.viewModel.deleteCategoryAction.apply(category).start()
            let actionPerformed = true
            completion(actionPerformed)
        })
        let config = UISwipeActionsConfiguration(actions: [editAction, deleteAction])
        return config
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = viewModel.categories.value[indexPath.row]
        self.viewModel.selectCategoryAction.apply(category).start()
    }
}
