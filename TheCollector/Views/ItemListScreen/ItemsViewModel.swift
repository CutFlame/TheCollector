//
//  ItemsViewModel.swift
//  TheCollector
//
//  Created by Michael Holt on 7/24/19.
//  Copyright © 2019 Michael Holt. All rights reserved.
//

import ReactiveSwift

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
