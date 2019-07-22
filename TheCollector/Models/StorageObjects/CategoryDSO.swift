//
//  CategoryDSO.swift
//  TheCollector
//
//  Created by Michael Holt on 7/22/19.
//  Copyright © 2019 Michael Holt. All rights reserved.
//

import RealmSwift

@objcMembers
class CategoryDSO: Object {
    @objc private dynamic var _id: String = String()
    var id: UUID {
        get { return UUID(uuidString: _id)! }
        set { _id = newValue.uuidString }
    }
    dynamic var name: String = String()
    private let _items: List<ItemDSO> = List<ItemDSO>()
    var items: [Item] {
        get { return Array(_items).map(Item.init) }
        set {
            _items.removeAll()
            _items.append(objectsIn: newValue.map { $0.toDSO() })
        }
    }

    override static func primaryKey() -> String? {
        return "_id"
    }
}

extension Category {
    internal init(_ dso: CategoryDSO) {
        self.id = dso.id
        self.name = dso.name
        self.items = dso.items
    }

    internal func toDSO() -> CategoryDSO {
        let dso = CategoryDSO()
        dso.id = self.id
        dso.name = self.name
        dso.items = self.items
        return dso
    }
}
