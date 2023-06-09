//
//  AppCoordinator.swift
//  GoCook
//
//  Created by Oleksii Andriushchenko on 13.06.2022.
//

import TabBar
import BusinessLogic
import Library
import Home
import UIKit

@MainActor
public final class AppCoordinator {

    // MARK: - Properties

    private var childCoordinators: [Coordinating]
    private let storage: Storage
    private let window: UIWindow

    // MARK: - Lifecycle

    public init(window: UIWindow) {
        self.childCoordinators = []
        self.storage = AppContainer.resolve()
        self.window = window
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

    private func isFirstSession() -> Bool {
        let isFirstSession = (try? storage.getBool(forKey: Constants.isFirstSessionKey)) == nil
        try? storage.store(bool: true, forKey: Constants.isFirstSessionKey)
        return isFirstSession
    }

    private func loadResources() {
        FontFamily.registerFonts()
    }

    private func showRegistration() {
        let coordinator = RegistrationCoordinator(navigationController: BaseNavigationController())
        coordinator.delegate = self
        coordinator.start()
        childCoordinators.append(coordinator)
        window.rootViewController = coordinator.rootViewController
    }

    private func showTabBar() {
        let coordinator = TabBarCoordinator()
        coordinator.delegate = self
        coordinator.start()
        childCoordinators.append(coordinator)
        window.rootViewController = coordinator.rootViewController
    }
}

// MARK: - TabBarCoordinatorDelegate

extension AppCoordinator: TabBarCoordinatorDelegate {
    func tabBarCoordinatorDidFinish() {
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
