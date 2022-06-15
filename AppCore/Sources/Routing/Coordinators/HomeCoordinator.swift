//
//  HomeCoordinator.swift
//  
//
//  Created by Oleksii Andriushchenko on 15.06.2022.
//

import Home
import UIKit

final class HomeCoordinator: Coordinating {

    private let navigationController: UINavigationController

    var rootViewController: UIViewController {
        navigationController
    }

    // MARK: - Lifecycle

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    // MARK: - Public methods

    func start() {
        let viewController = makeViewController()
        navigationController.pushViewController(viewController, animated: false)
    }

    // MARK: - Private methods

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

}
