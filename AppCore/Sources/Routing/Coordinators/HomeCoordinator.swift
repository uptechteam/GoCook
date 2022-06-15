//
//  HomeCoordinator.swift
//  
//
//  Created by Oleksii Andriushchenko on 15.06.2022.
//

import Filters
import Home
import Library
import UIKit

final class HomeCoordinator: Coordinating {

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

    private func makeViewController() -> HomeViewController {
        let dependencies = HomeViewController.Dependencies()
        return HomeViewController(
            store: HomeViewController.makeStore(dependencies: dependencies),
            actionCreator: HomeViewController.ActionCreator(dependencies: dependencies),
            coordinator: self
        )
    }
}

// MARK: - Extensions

extension HomeCoordinator: HomeCoordinating {
    func showFilters() {
        let dependencies = FiltersViewController.Dependencies()
        let viewController = FiltersViewController(
            store: FiltersViewController.makeStore(dependencies: dependencies),
            actionCreator: FiltersViewController.ActionCreator(dependencies: dependencies),
            coordinator: self
        )
        navigationController.pushViewController(viewController, animated: true)
    }
}

extension HomeCoordinator: FiltersCoordinating {
    
}
