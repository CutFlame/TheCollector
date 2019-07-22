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
    func saveCategory(category: Category) -> SignalProducer<Void, Never>
    func deleteCategory(id: UUID) -> SignalProducer<Void, Never>
}

enum Database {
    static let shared: DatabaseProtocol = RealmDatabase()
}

class InMemoryDatabase: DatabaseProtocol {
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

class RealmDatabase: DatabaseProtocol {
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

}
