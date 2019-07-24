//
//  ItemDSO.swift
//  TheCollector
//
//  Created by Michael Holt on 7/22/19.
//  Copyright © 2019 Michael Holt. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers
class ItemDSO: Object {
    @objc private dynamic var _itemID: String = String()
    var itemID: UUID {
        get { return UUID(uuidString: _itemID)! }
        set { _itemID = newValue.uuidString }
    }
    dynamic var title: String = String()
    dynamic var itemDescription: String = String()

    @objc private dynamic var _rating: Int = 0
    var rating: UInt8 {
        get { return UInt8(_rating) }
        set { _rating = Int(newValue) }
    }
    @objc private dynamic var _parentID: String = String()
    var parentID: UUID {
        get { return UUID(uuidString: _parentID)! }
        set { _parentID = newValue.uuidString }
    }

    override static func primaryKey() -> String? {
        return "_itemID"
    }
}

extension Item {
    internal init(_ dso: ItemDSO) {
        self.itemID = dso.itemID
        self.title = dso.title
        self.description = dso.itemDescription
        self.rating = dso.rating
        self.parentID = dso.parentID
    }

    internal func toDSO() -> ItemDSO {
        let dso = ItemDSO()
        dso.itemID = self.itemID
        dso.title = self.title
        dso.itemDescription = self.description
        dso.rating = self.rating
        dso.parentID = self.parentID
        return dso
    }
}
