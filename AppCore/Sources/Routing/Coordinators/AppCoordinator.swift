//
//  AppCoordinator.swift
//  GoCook
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

    private var childCoordinators: [Coordinating]
    private let container: DependencyContainer
    private let window: UIWindow
    private let storage: Storage

    // MARK: - Lifecycle

    public init(window: UIWindow) {
        self.childCoordinators = []
        self.container = .configure()
        self.window = window
        self.storage = try! container.resolve()
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
        let coordinator = RegistrationCoordinator(container: container, navigationController: navigationController)
        coordinator.delegate = self
        coordinator.start()
        childCoordinators.append(coordinator)
        window.rootViewController = coordinator.rootViewController
    }

    private func showTabBar() {
        let appTabBarController = AppTabBarController.resolve(from: container, coordinator: self)
        let coordinator = AppTabBarCoordinator(container: container, tabBarController: appTabBarController)
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
