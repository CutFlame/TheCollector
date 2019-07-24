//
//  Database.swift
//  TheCollector
//
//  Created by Michael Holt on 7/22/19.
//  Copyright © 2019 Michael Holt. All rights reserved.
//

import ReactiveSwift
import RealmSwift

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
    static let shared: DatabaseProtocol = InMemoryDatabase()
}

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
        return SignalProducer({ [weak self] observer, lifetime in
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
        return SignalProducer { [weak self] observer, lifetime in
            self?.items.removeAll()
            self?.categories.removeAll()
            observer.send(value: ())
            observer.sendCompleted()
        }
    }
}

/*
class RealmDatabase { //}: DatabaseProtocol {
    private let realm: Realm

    static func deleteRealm(at realmURL: URL) {
        let realmURLs = [
            realmURL,
            realmURL.appendingPathExtension("lock"),
            realmURL.appendingPathExtension("note"),
            realmURL.appendingPathExtension("management")
        ]
        for URL in realmURLs {
            do {
                try FileManager.default.removeItem(at: URL)
            } catch {
                print("\(error.localizedDescription)")
                // handle error
            }
        }
    }

    private static func createRealm(with configuration: Realm.Configuration) -> Realm {
        do {
            return try Realm(configuration: configuration)
        } catch let error {
            print("Could not create realm: \(error)")
            if let fileURL = configuration.fileURL {
                print("Deleting files to try again: \(fileURL.path)")
                RealmDatabase.deleteRealm(at: fileURL)
            }
        }
        //swiftlint:disable:next force_try
        return try! Realm(configuration: configuration)
    }

    init(_ configuration: Realm.Configuration = defaultConfiguration) {
        self.realm = RealmDatabase.createRealm(with: configuration)
        print("Realm initialized with path: \(configuration.fileURL?.path ?? "")")
        //print("Realm initialized with configuration: \(configuration)")
    }

    static var databaseBaseURL: URL = {
        var allDocumentsDirectories = FileManager.default.urls(for: FileManager.SearchPathDirectory.applicationSupportDirectory, in: FileManager.SearchPathDomainMask.userDomainMask)
        guard let documentsDirectory = allDocumentsDirectories.first else {
            fatalError("Could not acquire user's documents directory")
        }
        let baseURL = documentsDirectory
            .appendingPathComponent("Databases", isDirectory: true)
        try? FileManager.default.createDirectory(at: baseURL, withIntermediateDirectories: true, attributes: nil)
        return baseURL
    }()

    static var defaultConfiguration: Realm.Configuration = {
        var configuration = Realm.Configuration()
        configuration.deleteRealmIfMigrationNeeded = true
        configuration.fileURL = RealmDatabase.databaseBaseURL
            .appendingPathComponent("database.realm")
        return configuration
    }()

    func getCategories() -> SignalProducer<[Category], Never> {
        return SignalProducer { observer, _ in
            let results = Array(self.realm.objects(CategoryDSO.self).map(Category.init))
            observer.send(value: results)
            observer.sendCompleted()
        }
    }

    func saveCategory(category: Category) -> SignalProducer<Void, Never> {
        return SignalProducer { observer, _ in
            let obj = category.toDSO()
            try? self.realm.write {
                self.realm.add(obj, update: Realm.UpdatePolicy.all)
            }
            observer.send(value: ())
            observer.sendCompleted()
        }
    }

    func deleteCategory(id: UUID) -> SignalProducer<Void, Never> {
        return SignalProducer { observer, _ in
            if let obj = self.realm.object(ofType: CategoryDSO.self, forPrimaryKey: id.uuidString) {
                try? self.realm.write {
                    self.realm.delete(obj)
                }
            }
            observer.send(value: ())
            observer.sendCompleted()
        }
    }

    func getItems(forCategoryID id: UUID) -> SignalProducer<[Item], Never> {
        return SignalProducer { observer, _ in
            let results = self.realm.object(ofType: CategoryDSO.self, forPrimaryKey: id.uuidString).map(Category.init)
            observer.send(value: results?.items ?? [])
            observer.sendCompleted()
        }
    }

}
*/
