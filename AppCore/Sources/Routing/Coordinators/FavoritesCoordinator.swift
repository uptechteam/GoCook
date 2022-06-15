//
//  FavoritesCoordinator.swift
//  
//
//  Created by Oleksii Andriushchenko on 15.06.2022.
//

import Favorites
import Library
import UIKit

final class FavoritesCoordinator: Coordinating {

    // MARK: - Properties

    private let navigationController: UINavigationController

    var rootViewController: UIViewController {
        navigationController
    }

    // MARK: - Lifecycle

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        setupUI()
    }

    // MARK: - Public methods

    func start() {
        let viewController = makeViewController()
        navigationController.pushViewController(viewController, animated: false)
    }

    // MARK: - Private methods

    private func setupUI() {
        navigationController.navigationBar.titleTextAttributes = [
            .font: Typography.subtitleTwo.font,
            .foregroundColor: UIColor.textMain
        ]
    }

    private func makeViewController() -> FavoritesViewController {
        let dependencies = FavoritesViewController.Dependencies()
        return FavoritesViewController(
            store: FavoritesViewController.makeStore(dependencies: dependencies),
            actionCreator: FavoritesViewController.ActionCreator(dependencies: dependencies),
            coordinator: self
        )
    }
}

// MARK: - Extensions

extension FavoritesCoordinator: FavoritesCoordinating {

}
