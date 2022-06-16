//
//  HomeCoordinator.swift
//  
//
//  Created by Oleksii Andriushchenko on 15.06.2022.
//

import DomainModels
import Filters
import Foundation
import Home
import Library
import Recipe
import UIKit

final class HomeCoordinator: NSObject, Coordinating {

    private let navigationController: UINavigationController

    var rootViewController: UIViewController {
        navigationController
    }

    // MARK: - Lifecycle

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        super.init()
        setupUI()
    }

    // MARK: - Public methods

    func start() {
        let viewController = makeHomeViewController()
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
        let viewController = makeFiltersViewController()
        navigationController.pushViewController(viewController, animated: true)
    }

    func show(recipe: Recipe) {
        let viewController = makeRecipeViewController()
        navigationController.pushViewController(viewController, animated: true)
    }
}

extension HomeCoordinator: FiltersCoordinating {
    
}

extension HomeCoordinator: RecipeCoordinating {

}

// MARK: - UINavigationControllerdelegate

extension HomeCoordinator: UINavigationControllerDelegate {
    func navigationController(
        _ navigationController: UINavigationController,
        willShow viewController: UIViewController,
        animated: Bool
    ) {
        let isHidden = viewController is HomeViewController
        navigationController.setNavigationBarHidden(isHidden, animated: false)
    }
}

// MARK: - View controller factory

private extension HomeCoordinator {
    private func makeHomeViewController() -> UIViewController {
        let dependencies = HomeViewController.Dependencies()
        return HomeViewController(
            store: HomeViewController.makeStore(dependencies: dependencies),
            actionCreator: HomeViewController.ActionCreator(dependencies: dependencies),
            coordinator: self
        )
    }

    private func makeFiltersViewController() -> UIViewController {
        let dependencies = FiltersViewController.Dependencies()
        return FiltersViewController(
            store: FiltersViewController.makeStore(dependencies: dependencies),
            actionCreator: FiltersViewController.ActionCreator(dependencies: dependencies),
            coordinator: self
        )
    }

    private func makeRecipeViewController() -> UIViewController {
        let dependencies = RecipeViewController.Dependencies()
        return RecipeViewController(
            store: RecipeViewController.makeStore(dependencies: dependencies),
            actionCreator: RecipeViewController.ActionCreator(dependencies: dependencies),
            coordinator: self
        )
    }
}
