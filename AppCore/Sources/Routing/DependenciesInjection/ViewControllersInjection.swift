//
//  ViewControllersInjection.swift
//  
//
//  Created by Oleksii Andriushchenko on 21.06.2022.
//

import AppTabBar
import Dip
import Filters
import Home
import Recipe

extension DependencyContainer {
    public static func injectViewControllers(container: DependencyContainer) {
        injectAppTabBarController(container: container)
        injectHomeViewController(container: container)
        injectFiltersViewController(container: container)
        injectRecipeViewController(container: container)
    }

    // MARK: - App Tab Bar

    private static func injectAppTabBarController(container: DependencyContainer) {
        container.register(
            .shared,
            type: AppTabBarController.Dependencies.self,
            factory: AppTabBarController.Dependencies.init
        )
        container.register(
            .unique,
            type: AppTabBarController.Store.self,
            factory: AppTabBarController.makeStore(dependencies:)
        )
        container.register(
            .unique,
            type: AppTabBarController.ActionCreator.self,
            factory: AppTabBarController.ActionCreator.init
        )
        container.register(.unique, type: AppTabBarController.self) { (coordinator: AppTabBarCoordinating) in
            return AppTabBarController(
                store: try container.resolve(),
                actionCreator: try container.resolve(),
                coordinator: coordinator
            )
        }
    }

    // MARK: - Filters

    private static func injectFiltersViewController(container: DependencyContainer) {
        container.register(
            .shared,
            type: FiltersViewController.Dependencies.self,
            factory: FiltersViewController.Dependencies.init
        )
        container.register(
            .unique,
            type: FiltersViewController.Store.self,
            factory: FiltersViewController.makeStore
        )
        container.register(
            .unique,
            type: FiltersViewController.ActionCreator.self,
            factory: FiltersViewController.ActionCreator.init
        )
        container.register(.unique, type: FiltersViewController.self) { (coordinator: FiltersCoordinating) in
            return FiltersViewController(
                store: try container.resolve(),
                actionCreator: try container.resolve(),
                coordinator: coordinator
            )
        }
    }

    // MARK: - Home

    private static func injectHomeViewController(container: DependencyContainer) {
        container.register(
            .shared,
            type: HomeViewController.Dependencies.self,
            factory: HomeViewController.Dependencies.init
        )
        container.register(
            .unique,
            type: HomeViewController.Store.self,
            factory: HomeViewController.makeStore
        )
        container.register(
            .unique,
            type: HomeViewController.ActionCreator.self,
            factory: HomeViewController.ActionCreator.init
        )
        container.register(.unique, type: HomeViewController.self) { (coordinator: HomeCoordinating) in
            return HomeViewController(
                store: try container.resolve(),
                actionCreator: try container.resolve(),
                coordinator: coordinator
            )
        }
    }

    // MARK: - Recipe

    private static func injectRecipeViewController(container: DependencyContainer) {
        container.register(
            .shared,
            type: RecipeViewController.Dependencies.self,
            factory: RecipeViewController.Dependencies.init
        )
        container.register(
            .unique,
            type: RecipeViewController.Store.self,
            factory: RecipeViewController.makeStore
        )
        container.register(
            .unique,
            type: RecipeViewController.ActionCreator.self,
            factory: RecipeViewController.ActionCreator.init
        )
        container.register(.unique, type: RecipeViewController.self) { (coordinator: RecipeCoordinating) in
            return RecipeViewController(
                store: try container.resolve(),
                actionCreator: try container.resolve(),
                coordinator: coordinator
            )
        }
    }
}
