//
//  RealmDatabase.swift
//  TheCollector
//
//  Created by Michael Holt on 7/24/19.
//  Copyright © 2019 Michael Holt. All rights reserved.
//

import ReactiveSwift
import RealmSwift

class RealmDatabase {
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
}

extension RealmDatabase: DatabaseProtocol {
    func getCategories() -> SignalProducer<[Category], Never> {
        return SignalProducer { observer, _ in
            let results = self.realm.objects(CategoryDSO.self).map(Category.init)
            observer.send(value: Array(results))
            observer.sendCompleted()
        }
    }

    func getCategory(id: UUID) -> SignalProducer<Category?, Never> {
        return SignalProducer { observer, _ in
            let result = self.realm.object(ofType: CategoryDSO.self, forPrimaryKey: id.uuidString).map(Category.init)
            observer.send(value: result)
            observer.sendCompleted()
        }
    }

    func getItems(for categoryID: UUID) -> SignalProducer<[Item], Never> {
        return SignalProducer { observer, _ in
            let results = self.realm.objects(ItemDSO.self).filter({ $0.parentID == categoryID }).map(Item.init)
            observer.send(value: Array(results))
            observer.sendCompleted()
        }
    }

    func getItem(id: UUID) -> SignalProducer<Item?, Never> {
        return SignalProducer { observer, _ in
            let result = self.realm.object(ofType: ItemDSO.self, forPrimaryKey: id.uuidString).map(Item.init)
            observer.send(value: result)
            observer.sendCompleted()
        }
    }

    func save(category: Category) -> SignalProducer<Void, Never> {
        return SignalProducer { observer, _ in
            let obj = category.toDSO()
            try? self.realm.write {
                self.realm.add(obj, update: Realm.UpdatePolicy.all)
            }
            observer.send(value: ())
            observer.sendCompleted()
        }
    }
    func save(item: Item) -> SignalProducer<Void, Never> {
        return SignalProducer { observer, _ in
            let obj = item.toDSO()
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

    func deleteItem(id: UUID) -> SignalProducer<Void, Never> {
        return SignalProducer { observer, _ in
            if let obj = self.realm.object(ofType: ItemDSO.self, forPrimaryKey: id.uuidString) {
                try? self.realm.write {
                    self.realm.delete(obj)
                }
            }
            observer.send(value: ())
            observer.sendCompleted()
        }
    }

    func deleteAll() -> SignalProducer<Void, Never> {
        return SignalProducer { observer, _ in
            self.realm.deleteAll()
            observer.send(value: ())
            observer.sendCompleted()
        }

    }

}

