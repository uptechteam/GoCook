//
//  AppCoordinator.swift
//  Recipes
//
//  Created by Oleksii Andriushchenko on 13.06.2022.
//

import AppTabBar
import Library
import Feed
import UIKit

public final class AppCoordinator {

    // MARK: - Properties

    private let window: UIWindow
    private var childCoordinators: [Coordinating]

    // MARK: - Lifecycle

    public init(window: UIWindow) {
        self.window = window
        self.childCoordinators = []
        loadResources()
    }

    // MARK: - Public methods

    public func start() {
        window.makeKeyAndVisible()
        showTabBar()
    }

    // MARK: - Private methods

    private func loadResources() {
        FontFamily.registerFonts()
    }

    private func showTabBar() {
        let dependencies = AppTabBarController.Dependencies()
        let appTabBarController = AppTabBarController(
            store: AppTabBarController.makeStore(dependencies: dependencies),
            actionCreator: AppTabBarController.ActionCreator(dependencies: dependencies),
            coordinator: self
        )
        let coordinator = AppTabBarCoordinator(tabBarController: appTabBarController)
        coordinator.start()
        childCoordinators.append(coordinator)
        window.rootViewController = coordinator.rootViewController
    }
}

// MARK: - Extensions

extension AppCoordinator: AppTabBarCoordinating {

}
