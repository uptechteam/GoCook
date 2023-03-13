//
//  FavoritesCoordinator.swift
//  
//
//  Created by Oleksii Andriushchenko on 15.06.2022.
//

import Dip
import Favorites
import Filters
import Library
import UIKit

final class FavoritesCoordinator: Coordinating {

    // MARK: - Properties

    private let container: DependencyContainer
    private let navigationController: UINavigationController

    var rootViewController: UIViewController {
        navigationController
    }

    // MARK: - Lifecycle

    init(container: DependencyContainer, navigationController: UINavigationController) {
        self.container = container
        self.navigationController = navigationController
        setupUI()
    }

    // MARK: - Public methods

    func start() {
        let viewController = FavoritesViewController.resolve(from: container, coordinator: self)
        navigationController.pushViewController(viewController, animated: false)
    }

    // MARK: - Private methods

    private func setupUI() {
        navigationController.navigationBar.titleTextAttributes = [
            .font: Typography.subtitleTwo.font,
            .foregroundColor: UIColor.textMain
        ]
    }
}

// MARK: - FavoritesCoordinating

extension FavoritesCoordinator: FavoritesCoordinating {
    func didTapFilters() {
        let viewController = FiltersViewController.resolve(from: container, coordinator: self)
        navigationController.pushViewController(viewController, animated: true)
    }
}

// MARK: - FiltersCoordinating

extension FavoritesCoordinator: FiltersCoordinating {

}
