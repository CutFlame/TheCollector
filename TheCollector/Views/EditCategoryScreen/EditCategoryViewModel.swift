//
//  EditCategoryViewModel.swift
//  TheCollector
//
//  Created by Michael Holt on 7/22/19.
//  Copyright © 2019 Michael Holt. All rights reserved.
//

import ReactiveSwift

class EditCategoryViewModel {
    private let database: DatabaseProtocol
    let category: Category?
    init(category: Category? = nil, database: DatabaseProtocol = Database.shared) {
        self.database = database
        self.category = category
        self.name.value = category?.name
    }

    let name = MutableProperty<String?>(nil)
    private lazy var formValid = name.map({ $0 != nil && !$0!.isEmpty })

    lazy private(set) var saveAction = Action<Void, Void, Never>(enabledIf: formValid, execute: self.saveSignal)
    private func saveSignal() -> SignalProducer<Void, Never> {
        let newCategory = Category(
            id: self.category?.id ?? UUID(),
            name: self.name.value ?? "Unnamed Category",
            items: self.category?.items ?? [])
        return database.saveCategory(category: newCategory)
    }
    let cancelAction = Action<Void, Void, Never>(execute: { SignalProducer(value: ()) })
}
