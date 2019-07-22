//
//  AppCoordinator.swift
//  TheCollector
//
//  Created by Michael Holt on 7/22/19.
//  Copyright © 2019 Michael Holt. All rights reserved.
//

import ReactiveSwift
import UIKit

class AppCoordinator: Coordinator, CoordinatorProtocol {
    let window: UIWindow
    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        showLaunchScreen()

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.showCategoriesScreen()
        }
    }

    func showLaunchScreen() {
        let viewController = LaunchViewController()
        window.rootViewController = viewController
    }

    func showCategoriesScreen() {
        let viewModel = CategoriesViewModel()
        viewModel.addCategoryAction.values.observeValues { [weak self] in
            self?.showEditCategoryScreen()
        }
        viewModel.editCategoryAction.values.observeValues { [weak self] category in
            self?.showEditCategoryScreen(category: category)
        }
        let viewController = CategoriesViewController()
        viewController.viewModel = viewModel
        let navController = UINavigationController(rootViewController: viewController)
        window.rootViewController = navController
    }

    func showEditCategoryScreen(category: Category? = nil) {
        let viewModel = EditCategoryViewModel(category: category)
        viewModel.saveAction.values.merge(with: viewModel.cancelAction.values)
            .observeValues { [weak self] in
                self?.window.rootViewController?.dismiss(animated: true, completion: nil)
        }
        let viewController = EditCategoryViewController()
        viewController.viewModel = viewModel
        let navController = UINavigationController(rootViewController: viewController)
        window.rootViewController?.present(navController, animated: true, completion: nil)
    }
}
