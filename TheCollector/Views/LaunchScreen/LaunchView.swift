//
//  LaunchView.swift
//  TheCollector
//
//  Created by Michael Holt on 7/22/19.
//  Copyright © 2019 Michael Holt. All rights reserved.
//

import UIKit

class LaunchView: UIView {
    let mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 42)
        label.textAlignment = .center
        label.text = "The Collector"
        label.textColor = .black
        return label
    }()

    init() {
        super.init(frame: CGRect.zero)
        self.backgroundColor = .white
        addSubview(mainLabel)
        addConstraints([
            mainLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            mainLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
