//
//  ItemCell.swift
//  TheCollector
//
//  Created by Michael Holt on 7/24/19.
//  Copyright © 2019 Michael Holt. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
