//
//  EditItemViewModel.swift
//  TheCollector
//
//  Created by Michael Holt on 7/24/19.
//  Copyright © 2019 Michael Holt. All rights reserved.
//

import ReactiveSwift

class EditItemViewModel {
    private let database: DatabaseProtocol
    let category: Category
    let item: Item?
    init(category: Category, item: Item? = nil, database: DatabaseProtocol = Database.shared) {
        self.database = database
        self.category = category
        self.item = item
        self.title.value = item?.title
        self.description.value = item?.description
        self.rating.value = item?.rating ?? 3
    }

    let title = MutableProperty<String?>(nil)
    let description = MutableProperty<String?>(nil)
    let rating = MutableProperty<UInt8>(0)
    private lazy var formValid = title.map({ $0 != nil && !$0!.isEmpty })
        .combineLatest(with: description.map({ $0 != nil && !$0!.isEmpty }))
        .map { (titleValid, descriptionValid) in
            return titleValid && descriptionValid
    }

    lazy private(set) var saveAction = Action<Void, Void, Never>(enabledIf: formValid, execute: self.saveSignal)
    private func saveSignal() -> SignalProducer<Void, Never> {
        let newItem = Item(
            itemID: self.item?.itemID ?? UUID(),
            title: self.title.value ?? "No Title",
            description: self.description.value ?? "No Description",
            rating: self.rating.value,
            parentID: self.category.categoryID)
        let newCategory = Category(
            categoryID: self.category.categoryID,
            name: self.category.name,
            itemIDs: self.category.itemIDs + [newItem.itemID])
        return SignalProducer.combineLatest(
            database.save(category: newCategory),
            database.save(item: newItem))
            .map { _ in }
    }
    let cancelAction = Action<Void, Void, Never>(execute: { SignalProducer(value: ()) })
}
