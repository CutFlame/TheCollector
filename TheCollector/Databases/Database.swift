//
//  Database.swift
//  TheCollector
//
//  Created by Michael Holt on 7/22/19.
//  Copyright © 2019 Michael Holt. All rights reserved.
//

import ReactiveSwift

protocol DatabaseProtocol {
    func getCategories() -> SignalProducer<[Category], Never>
    func getCategory(id: UUID) -> SignalProducer<Category?, Never>
    func getItems(for categoryID: UUID) -> SignalProducer<[Item], Never>
    func getItem(id: UUID) -> SignalProducer<Item?, Never>
    func save(category: Category) -> SignalProducer<Void, Never>
    func save(item: Item) -> SignalProducer<Void, Never>
    func deleteCategory(id: UUID) -> SignalProducer<Void, Never>
    func deleteItem(id: UUID) -> SignalProducer<Void, Never>
    func deleteAll() -> SignalProducer<Void, Never>
}

enum Database {
    static var shared: DatabaseProtocol = RealmDatabase()
}
