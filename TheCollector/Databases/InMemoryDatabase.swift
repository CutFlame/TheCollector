//
//  InMemoryDatabase.swift
//  TheCollector
//
//  Created by Michael Holt on 7/24/19.
//  Copyright © 2019 Michael Holt. All rights reserved.
//

import ReactiveSwift

class InMemoryDatabase: DatabaseProtocol {
    private var categories = [UUID: Category]()
    private var items = [UUID: Item]()

    func getCategories() -> SignalProducer<[Category], Never> {
        return SignalProducer(value: Array(categories.values))
    }

    func getCategory(id: UUID) -> SignalProducer<Category?, Never> {
        return SignalProducer(value: categories[id])
    }

    func getItems(for categoryID: UUID) -> SignalProducer<[Item], Never> {
        return SignalProducer(value: items.values.filter({ $0.parentID == categoryID }))
    }

    func getItem(id: UUID) -> SignalProducer<Item?, Never> {
        return SignalProducer(value: items[id])
    }

    func save(category: Category) -> SignalProducer<Void, Never> {
        return SignalProducer { [weak self] in
            self?.categories[category.categoryID] = category
        }
    }
    func save(item: Item) -> SignalProducer<Void, Never> {
        return SignalProducer { [weak self] in
            self?.items[item.itemID] = item
        }
    }

    func deleteCategory(id: UUID) -> SignalProducer<Void, Never> {
        return SignalProducer({ [weak self] observer, _ in
            //Cascade delete the items
            if let category = self?.categories[id] {
                let itemIDs = category.itemIDs
                itemIDs.forEach { self?.items.removeValue(forKey: $0) }
            }

            //delete the category
            self?.categories.removeValue(forKey: id)
            observer.send(value: ())
            observer.sendCompleted()
        })
    }

    func deleteItem(id: UUID) -> SignalProducer<Void, Never> {
        return SignalProducer { [weak self] in
            self?.items.removeValue(forKey: id)
        }
    }

    func deleteAll() -> SignalProducer<Void, Never> {
        return SignalProducer { [weak self] observer, _ in
            self?.items.removeAll()
            self?.categories.removeAll()
            observer.send(value: ())
            observer.sendCompleted()
        }
    }
}
