//
//  LaunchViewController.swift
//  TheCollector
//
//  Created by Michael Holt on 7/22/19.
//  Copyright © 2019 Michael Holt. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {
    let contentView = LaunchView()

    override func loadView() {
        super.loadView()
        view = contentView
    }
}
