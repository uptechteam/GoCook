//
//  AppCoordinator.swift
//  Recipes
//
//  Created by Oleksii Andriushchenko on 13.06.2022.
//

import AppTabBar
import BusinessLogic
import Dip
import Library
import Home
import UIKit

@MainActor
public final class AppCoordinator {

    // MARK: - Properties

    private let container: DependencyContainer
    private let window: UIWindow
    private var childCoordinators: [Coordinating]

    // MARK: - Lifecycle

    public init(window: UIWindow) {
        self.container = .configure()
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
        let appTabBarController: AppTabBarController = try! container.resolve(arguments: self as AppTabBarCoordinating)
        let coordinator = AppTabBarCoordinator(container: container, tabBarController: appTabBarController)
        coordinator.start()
        childCoordinators.append(coordinator)
        window.rootViewController = coordinator.rootViewController
    }
}

// MARK: - Extensions

extension AppCoordinator: AppTabBarCoordinating {

}
