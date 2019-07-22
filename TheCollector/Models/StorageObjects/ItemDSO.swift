//
//  ItemDSO.swift
//  TheCollector
//
//  Created by Michael Holt on 7/22/19.
//  Copyright © 2019 Michael Holt. All rights reserved.
//

import RealmSwift

@objcMembers
class ItemDSO: Object {
    @objc private dynamic var _id: String = String()
    var id: UUID {
        get { return UUID(uuidString: _id)! }
        set { _id = newValue.uuidString }
    }
    dynamic var title: String = String()
    dynamic var itemDescription: String = String()

    @objc private dynamic var _rating: Int = 0
    var rating: UInt8 {
        get { return UInt8(_rating) }
        set { _rating = Int(newValue) }
    }

    override static func primaryKey() -> String? {
        return "_id"
    }
}

extension Item {
    internal init(_ dso: ItemDSO) {
        self.id = dso.id
        self.title = dso.title
        self.description = dso.itemDescription
        self.rating = dso.rating
    }

    internal func toDSO() -> ItemDSO {
        let dso = ItemDSO()
        dso.id = self.id
        dso.title = self.title
        dso.itemDescription = self.description
        dso.rating = self.rating
        return dso
    }
}
