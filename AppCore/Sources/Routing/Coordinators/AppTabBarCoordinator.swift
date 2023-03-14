//
//  AppTabBarCoordinator.swift
//  
//
//  Created by Oleksii Andriushchenko on 15.06.2022.
//

import AppTabBar
import Dip
import BusinessLogic
import Library
import UIKit

protocol AppTabBarCoordinatorDelegate: AnyObject {
    func appTabBarCoordinatorDidFinish()
}

final class AppTabBarCoordinator: Coordinating {

    // MARK: - Properties

    private let container: DependencyContainer
    private let tabBarController: AppTabBarController
    private var childCoordinators: [Coordinating]
    weak var delegate: AppTabBarCoordinatorDelegate?

    var rootViewController: UIViewController {
        tabBarController
    }

    // MARK: - Lifecycle

    init(container: DependencyContainer, tabBarController: AppTabBarController) {
        self.container = container
        self.tabBarController = tabBarController
        self.childCoordinators = []
    }

    // MARK: - Public methods

    func start() {
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
        childCoordinators.append(coordinator)
    }

    private func makeHomeCoordinator() {
        let coordinator = HomeCoordinator(container: container, navigationController: BaseNavigationController())
        childCoordinators.append(coordinator)
    }

    private func makeProfileCoordinator() {
        let coordinator = ProfileCoordinator(container: container, navigationController: BaseNavigationController())
        coordinator.delegate = self
        childCoordinators.append(coordinator)
    }
}

// MARK: - ProfileCoordinatorDelegate

extension AppTabBarCoordinator: ProfileCoordinatorDelegate {
    func profileCoordinatorDidFinish(_ coordinator: ProfileCoordinator) {
        delegate?.appTabBarCoordinatorDidFinish()
    }
}
