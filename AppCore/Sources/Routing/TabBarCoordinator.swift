//
//  TabBarCoordinator.swift
//  
//
//  Created by Oleksii Andriushchenko on 15.06.2022.
//

import BusinessLogic
import Library
import TabBar
import UIKit

protocol TabBarCoordinatorDelegate: AnyObject {
    func tabBarCoordinatorDidFinish()
}

final class TabBarCoordinator: Coordinating {

    // MARK: - Properties

    private var childCoordinators: [Coordinating]
    weak var delegate: TabBarCoordinatorDelegate?
    private var tabBarController: TabBarController!

    var rootViewController: UIViewController {
        tabBarController
    }

    // MARK: - Lifecycle

    init() {
        self.childCoordinators = []
    }

    // MARK: - Public methods

    func start() {
        self.tabBarController = TabBarController.resolve(coordinator: self)
        makeFavoritesCoordinator()
        makeHomeCoordinator()
        makeProfileCoordinator()
        childCoordinators.forEach { $0.start() }
        tabBarController.viewControllers = childCoordinators.map(\.rootViewController)
        tabBarController.selectInitialIndex()
    }

    // MARK: - Private methods

    private func makeFavoritesCoordinator() {
        let coordinator = FavoritesCoordinator(navigationController: BaseNavigationController())
        coordinator.delegate = self
        childCoordinators.append(coordinator)
    }

    private func makeHomeCoordinator() {
        let coordinator = HomeCoordinator(navigationController: BaseNavigationController())
        childCoordinators.append(coordinator)
    }

    private func makeProfileCoordinator() {
        let coordinator = ProfileCoordinator(navigationController: BaseNavigationController())
        coordinator.delegate = self
        childCoordinators.append(coordinator)
    }
}

// MARK: - FavoritesCoordinatorDelegate

extension TabBarCoordinator: FavoritesCoordinatorDelegate {
    func didTapExplore() {
        tabBarController.select(tabIndex: 1)
    }
}

// MARK: - ProfileCoordinatorDelegate

extension TabBarCoordinator: ProfileCoordinatorDelegate {
    func profileCoordinatorDidFinish(_ coordinator: ProfileCoordinator) {
        delegate?.tabBarCoordinatorDidFinish()
    }
}

// MARK: - TabBarCoordinating

extension TabBarCoordinator: TabBarCoordinating {

}
