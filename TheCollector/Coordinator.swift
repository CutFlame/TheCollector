//
//  Coordinator.swift
//  TheCollector
//
//  Created by Michael Holt on 7/22/19.
//  Copyright © 2019 Michael Holt. All rights reserved.
//

import Foundation

protocol CoordinatorProtocol {
    var child: CoordinatorProtocol? { get set }
    func start()
}

class Coordinator {
    var child: CoordinatorProtocol? = nil
}
