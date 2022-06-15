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

    // MARK: - Lifecycle

    public init(window: UIWindow) {
        self.window = window
        loadResources()
    }

    // MARK: - Public methods

    public func start() {
        window.makeKeyAndVisible()
        showFeed()
    }

    // MARK: - Private methods

    private func loadResources() {
        FontFamily.registerFonts()
    }

    private func showFeed() {
        let dependencies = FeedViewController.Dependencies()
        let viewController = FeedViewController(
            store: FeedViewController.makeStore(dependencies: dependencies),
            actionCreator: FeedViewController.ActionCreator(dependencies: dependencies),
            coordinator: self
        )

        let tabBarDependencies = AppTabBarController.Dependencies()
        let tabBarController = AppTabBarController(
            store: AppTabBarController.makeStore(dependencies: tabBarDependencies),
            actionCreator: AppTabBarController.ActionCreator(dependencies: tabBarDependencies),
            coordinator: self
        )
        tabBarController.viewControllers = [viewController]

        window.rootViewController = tabBarController
    }
}

extension AppCoordinator: FeedCoordinating {

}

extension AppCoordinator: AppTabBarCoordinating {

}
