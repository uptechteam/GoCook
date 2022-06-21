//
//  HomeCoordinator.swift
//  
//
//  Created by Oleksii Andriushchenko on 15.06.2022.
//

import AppTabBar
import BusinessLogic
import DomainModels
import Dip
import Filters
import Foundation
import Home
import Library
import Recipe
import UIKit

final class HomeCoordinator: NSObject, Coordinating {

    // MARK: - Properties

    private let container: DependencyContainer
    private let navigationController: UINavigationController

    var rootViewController: UIViewController {
        navigationController
    }

    // MARK: - Lifecycle

    init(container: DependencyContainer, navigationController: UINavigationController) {
        self.container = container
        self.navigationController = navigationController
        super.init()
        setupUI()
    }

    // MARK: - Public methods

    func start() {
        let viewController: HomeViewController = try! container.resolve(arguments: self as HomeCoordinating)
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

// MARK: - Coordinating extensions

extension HomeCoordinator: HomeCoordinating {
    func showFilters() {
        let viewController: FiltersViewController = try! container.resolve(arguments: self as FiltersCoordinating)
        navigationController.pushViewController(viewController, animated: true)
    }

    func show(recipe: Recipe) {
        let envelope = RecipeEnvelope(recipe: recipe)
        let viewController: RecipeViewController = try! container.resolve(
            arguments: envelope, self as RecipeCoordinating
        )
        navigationController.pushViewController(viewController, animated: true)
    }
}

extension HomeCoordinator: FiltersCoordinating {
    
}

extension HomeCoordinator: RecipeCoordinating {
    func didTapBack() {
        navigationController.popViewController(animated: true)
    }
}

// MARK: - UINavigationControllerdelegate

extension HomeCoordinator: UINavigationControllerDelegate {
    func navigationController(
        _ navigationController: UINavigationController,
        willShow viewController: UIViewController,
        animated: Bool
    ) {
        let isHidden = viewController is HomeViewController || viewController is RecipeViewController
        navigationController.setNavigationBarHidden(isHidden, animated: false)
    }

    func navigationController(
        _ navigationController: UINavigationController,
        didShow viewController: UIViewController,
        animated: Bool
    ) {
        let isTabBarVisible = viewController is HomeViewController
        (navigationController.tabBarController as? AppTabBarController)?.toggleTabBarVisibility(on: isTabBarVisible)
    }
}
