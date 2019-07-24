//
//  ItemsViewController.swift
//  TheCollector
//
//  Created by Michael Holt on 7/22/19.
//  Copyright © 2019 Michael Holt. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

class ItemsViewController: UITableViewController {
    let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)

    var viewModel: ItemsViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        if viewModel == nil {
            fatalError("Set the ViewModel before allowing the ViewController to be displayed")
        }

        title = "Items"

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ItemCell")
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let item = viewModel.items.value[indexPath.row]
        cell.textLabel?.text = item.title
        return cell
    }

    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let item = viewModel.items.value[indexPath.row]
        let editAction = UIContextualAction(style: .normal, title: "Edit", handler: { [weak self] _, _, _ in
            self?.viewModel.editItemAction.apply(item).start()
        })
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete", handler: { [weak self] _, _, completion in
            self?.viewModel.deleteItemAction.apply(item).start()
            let actionPerformed = true
            completion(actionPerformed)
        })
        let config = UISwipeActionsConfiguration(actions: [editAction, deleteAction])
        return config
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = viewModel.items.value[indexPath.row]
        self.viewModel.selectItemAction.apply(item).start()
    }
}

class ItemsViewModel {
    let category: Category
    private let database: DatabaseProtocol
    init(category: Category, database: DatabaseProtocol = Database.shared) {
        self.category = category
        self.database = database
    }

    let items = MutableProperty<[Item]>([])

    lazy private(set) var fetchAction = Action<Void, Void, Never>(execute: fetchSignal)
    private func fetchSignal() -> SignalProducer<Void, Never> {
        return database.getItems(for: category.categoryID)
            .on { [weak self] in self?.items.value = $0 }
            .map { _ in }
    }

    let addItemAction = Action<Void, Void, Never>(execute: { SignalProducer(value: ()) })
    let editItemAction = Action<Item, Item, Never>(execute: { input in SignalProducer(value: input) })
    let selectItemAction = Action<Item, Item, Never>(execute: { input in SignalProducer(value: input) })

    lazy private(set) var deleteItemAction = Action<Item, Void, Never>(execute: self.deleteItemSignal)
    private func deleteItemSignal(item: Item) -> SignalProducer<Void, Never> {
        let id = item.itemID
        return database.deleteItem(id: id)
            .on { [weak self] in
                guard let self = self else { return }
                self.items.value = self.items.value.filter({ $0.itemID != id })
            }
            .map { _ in }
    }

}
