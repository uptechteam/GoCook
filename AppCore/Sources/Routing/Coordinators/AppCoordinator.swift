//
//  AppCoordinator.swift
//  GoCook
//
//  Created by Oleksii Andriushchenko on 13.06.2022.
//

import AppTabBar
import BusinessLogic
import Library
import Home
import UIKit

@MainActor
public final class AppCoordinator {

    // MARK: - Properties

    private var childCoordinators: [Coordinating]
    private let window: UIWindow
    private let storage: Storage

    // MARK: - Lifecycle

    public init(window: UIWindow) {
        self.childCoordinators = []
        self.window = window
        self.storage = AppContainer.resolve()
        loadResources()
    }

    // MARK: - Public methods

    public func start() {
        window.makeKeyAndVisible()
        if isFirstSession() {
            showRegistration()
        } else {
            showTabBar()
        }
    }

    // MARK: - Private methods

    private func loadResources() {
        FontFamily.registerFonts()
    }

    private func showRegistration() {
        let navigationController = UINavigationController()
        let coordinator = RegistrationCoordinator(navigationController: navigationController)
        coordinator.delegate = self
        coordinator.start()
        childCoordinators.append(coordinator)
        window.rootViewController = coordinator.rootViewController
    }

    private func showTabBar() {
        let appTabBarController = AppTabBarController.resolve(coordinator: self)
        let coordinator = AppTabBarCoordinator(tabBarController: appTabBarController)
        coordinator.delegate = self
        coordinator.start()
        childCoordinators.append(coordinator)
        window.rootViewController = coordinator.rootViewController
    }

    private func isFirstSession() -> Bool {
        let isFirstSession = (try? storage.getBool(forKey: Constants.isFirstSessionKey)) == nil
        try? storage.store(bool: true, forKey: Constants.isFirstSessionKey)
        return isFirstSession
    }
}

// MARK: - AppTabBarCoordinating

extension AppCoordinator: AppTabBarCoordinating {

}

// MARK: - AppTabBarCoordinatorDelegate

extension AppCoordinator: AppTabBarCoordinatorDelegate {
    func appTabBarCoordinatorDidFinish() {
        childCoordinators.removeAll()
        showRegistration()
    }
}

// MARK: - RegistrationCoordinatorDelegate

extension AppCoordinator: RegistrationCoordinatorDelegate {
    func registrationCoordiantorDidFinish(_ coordinator: RegistrationCoordinator) {
        childCoordinators.removeAll()
        showTabBar()
    }
}

// MARK: - Constants

extension AppCoordinator {
    private enum Constants {
        static let isFirstSessionKey = "AppCoordinator.isFirstSessionKey"
    }
}
