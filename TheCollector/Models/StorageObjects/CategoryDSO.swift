//
//  CategoryDSO.swift
//  TheCollector
//
//  Created by Michael Holt on 7/22/19.
//  Copyright © 2019 Michael Holt. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers
class CategoryDSO: Object {
    @objc private dynamic var _categoryID: String = String()
    var categoryID: UUID {
        get { return UUID(uuidString: _categoryID)! }
        set { _categoryID = newValue.uuidString }
    }
    dynamic var name: String = String()
    private let _itemIDs: List<String> = List<String>()
    var itemIDs: [UUID] {
        get { return Array(_itemIDs).compactMap(UUID.init) }
        set {
            _itemIDs.removeAll()
            _itemIDs.append(objectsIn: newValue.map { $0.uuidString })
        }
    }

    override static func primaryKey() -> String? {
        return "_categoryID"
    }
}

extension Category {
    internal init(_ dso: CategoryDSO) {
        self.categoryID = dso.categoryID
        self.name = dso.name
        self.itemIDs = dso.itemIDs
    }

    internal func toDSO() -> CategoryDSO {
        let dso = CategoryDSO()
        dso.categoryID = self.categoryID
        dso.name = self.name
        dso.itemIDs = self.itemIDs
        return dso
    }
}
