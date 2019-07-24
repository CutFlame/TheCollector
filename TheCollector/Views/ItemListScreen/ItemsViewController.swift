//
//  ItemsViewController.swift
//  TheCollector
//
//  Created by Michael Holt on 7/22/19.
//  Copyright © 2019 Michael Holt. All rights reserved.
//

import ReactiveCocoa
import ReactiveSwift
import UIKit

class ItemsViewController: UITableViewController {
    let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)

    var viewModel: ItemsViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        if viewModel == nil {
            fatalError("Set the ViewModel before allowing the ViewController to be displayed")
        }

        title = "Items"

        tableView.register(ItemCell.self, forCellReuseIdentifier: "ItemCell")
        navigationItem.rightBarButtonItem = addButton

        bindToViewModel()
    }

    private func bindToViewModel() {
        addButton.reactive.pressed = CocoaAction(viewModel.addItemAction)
        addButton.reactive.isEnabled <~ viewModel.addItemAction.isEnabled
        viewModel.fetchAction.values.observeValues { [weak self] in self?.tableView.reloadData() }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchAction.apply().start()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.value.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        let item = viewModel.items.value[indexPath.row]
        cell.textLabel?.text = item.title
        cell.detailTextLabel?.text = item.description
        return cell
    }

    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let item = viewModel.items.value[indexPath.row]
        let editAction = UIContextualAction(style: .normal, title: "Edit", handler: { [weak self] _, _, _ in
            self?.viewModel.editItemAction.apply(item).start()
        })
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete", handler: { [weak self] _, _, completion in
            self?.viewModel.deleteItemAction.apply(item).startWithResult({ _ in
                let actionPerformed = true
                completion(actionPerformed)
                DispatchQueue.main.async {
                    self?.viewModel.fetchAction.apply().start()
                }
            })
        })
        let config = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        return config
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = viewModel.items.value[indexPath.row]
        self.viewModel.selectItemAction.apply(item).start()
    }
}
