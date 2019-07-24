//
//  CategoriesViewModel.swift
//  TheCollector
//
//  Created by Michael Holt on 7/22/19.
//  Copyright © 2019 Michael Holt. All rights reserved.
//

import ReactiveSwift

class CategoriesViewModel {
    private let database: DatabaseProtocol
    init(database: DatabaseProtocol = Database.shared) {
        self.database = database
    }

    let categories = MutableProperty<[Category]>([])

    lazy private(set) var fetchAction = Action<Void, Void, Never>(execute: fetchSignal)
    private func fetchSignal() -> SignalProducer<Void, Never> {
        return database.getCategories()
            .on { [weak self] in self?.categories.value = $0 }
            .map { _ in }
    }

    let addCategoryAction = Action<Void, Void, Never>(execute: { SignalProducer(value: ()) })
    let editCategoryAction = Action<Category, Category, Never>(execute: { input in SignalProducer(value: input) })
    let selectCategoryAction = Action<Category, Category, Never>(execute: { input in SignalProducer(value: input) })

    lazy private(set) var deleteCategoryAction = Action<Category, Void, Never>(execute: self.deleteCategorySignal)
    private func deleteCategorySignal(category: Category) -> SignalProducer<Void, Never> {
        let id = category.categoryID
        return database.deleteCategory(id: id)
            .on { [weak self] in
                guard let self = self else { return }
                self.categories.value = self.categories.value.filter({ $0.categoryID != id })
            }
            .map { _ in }
    }

}
