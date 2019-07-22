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
    func saveCategory(category: Category) -> SignalProducer<Void, Never>
    func deleteCategory(id: UUID) -> SignalProducer<Void, Never>
}

class Database: DatabaseProtocol {
    static let shared = Database()

    //TODO: persistence here
    private var categories = [UUID: Category]()

    func getCategories() -> SignalProducer<[Category], Never> {
        return SignalProducer(value: Array(categories.values))
    }

    func saveCategory(category: Category) -> SignalProducer<Void, Never> {
        return SignalProducer { [weak self] in
            self?.categories[category.id] = category
        }
    }

    func deleteCategory(id: UUID) -> SignalProducer<Void, Never> {
        return SignalProducer { [weak self] in
            self?.categories.removeValue(forKey: id)
        }
    }
}
