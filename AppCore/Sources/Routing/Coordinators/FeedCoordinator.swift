//
//  File.swift
//  
//
//  Created by Oleksii Andriushchenko on 15.06.2022.
//

import Feed
import UIKit

final class FeedCoordinator: Coordinating {

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

    private func makeViewController() -> FeedViewController {
        let dependencies = FeedViewController.Dependencies()
        return FeedViewController(
            store: FeedViewController.makeStore(dependencies: dependencies),
            actionCreator: FeedViewController.ActionCreator(dependencies: dependencies),
            coordinator: self
        )
    }
}

// MARK: - Extensions

extension FeedCoordinator: FeedCoordinating {

}
