//
//  ProfileCoordinator.swift
//  
//
//  Created by Oleksii Andriushchenko on 15.06.2022.
//

import AppTabBar
import CreateRecipe
import Dip
import Foundation
import Library
import Profile
import UIKit

final class ProfileCoordinator: NSObject, Coordinating {

    // MARK: - Properties

    private var childCoordinators: [Coordinating]
    private let container: DependencyContainer
    private let navigationController: UINavigationController

    var rootViewController: UIViewController {
        navigationController
    }

    // MARK: - Lifecycle

    init(container: DependencyContainer, navigationController: UINavigationController) {
        self.childCoordinators = []
        self.container = container
        self.navigationController = navigationController
        super.init()
        setupUI()
    }

    // MARK: - Lifecycle

    func start() {
        let viewController: ProfileViewController = try! container.resolve(arguments: self as ProfileCoordinating)
        navigationController.pushViewController(viewController, animated: false)
    }

    // MARK: - Private methods

    private func setupUI() {
        navigationController.delegate = self
        navigationController.navigationBar.titleTextAttributes = [
            .font: Typography.subtitleTwo.font,
            .foregroundColor: UIColor.textMain
        ]
    }
}

// MARK: - Extensions

extension ProfileCoordinator: ProfileCoordinating {
    func didTapCreateRecipe() {
        let coordinator = CreateRecipeCoordinator(container: container, presentingViewController: navigationController)
        childCoordinators.append(coordinator)
        coordinator.start()
    }
}

extension ProfileCoordinator: CreateRecipeCoordinatorDelegate {
    func didFinish(_ coordinator: CreateRecipeCoordinator) {
        childCoordinators.removeAll(where: { $0 === coordinator })
    }
}

// MARK: - UINavigationControllerdelegate

extension ProfileCoordinator: UINavigationControllerDelegate {
    func navigationController(
        _ navigationController: UINavigationController,
        willShow viewController: UIViewController,
        animated: Bool
    ) {
        let isHidden = viewController is ProfileViewController
        navigationController.setNavigationBarHidden(isHidden, animated: false)
    }

    func navigationController(
        _ navigationController: UINavigationController,
        didShow viewController: UIViewController,
        animated: Bool
    ) {
        let isTabBarVisible = viewController is ProfileViewController
        (navigationController.tabBarController as? AppTabBarController)?.toggleTabBarVisibility(on: isTabBarVisible)
    }
}
