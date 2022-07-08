//
//  ViewControllersInjection.swift
//  
//
//  Created by Oleksii Andriushchenko on 21.06.2022.
//

import AppTabBar
import CreateRecipe
import Dip
import Filters
import Home
import Input
import Login
import Recipe
import Profile
import SignUp

extension DependencyContainer {
    public static func injectViewControllers(container: DependencyContainer) {
        injectAppTabBarController(container: container)
        injectCreateRecipeViewController(container: container)
        injectHomeViewController(container: container)
        injectFiltersViewController(container: container)
        injectInputViewController(container: container)
        injectLoginViewController(container: container)
        injectRecipeViewController(container: container)
        injectProfileViewController(container: container)
        injectSignUpViewController(container: container)
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
        container.register(.unique, type: AppTabBarController.self) { coordinator in
            return AppTabBarController(
                store: try container.resolve(),
                actionCreator: try container.resolve(),
                coordinator: coordinator
            )
        }
    }

    // MARK: - Create Recipe

    private static func injectCreateRecipeViewController(container: DependencyContainer) {
        container.register(
            .shared,
            type: CreateRecipeViewController.Dependencies.self,
            factory: CreateRecipeViewController.Dependencies.init
        )
        container.register(
            .unique,
            type: CreateRecipeViewController.Store.self,
            factory: CreateRecipeViewController.makeStore
        )
        container.register(
            .unique,
            type: CreateRecipeViewController.ActionCreator.self,
            factory: CreateRecipeViewController.ActionCreator.init
        )
        container.register(.unique, type: CreateRecipeViewController.self) { coordinator in
            return CreateRecipeViewController(
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
        container.register(.unique, type: FiltersViewController.self) { coordinator in
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
        container.register(.unique, type: HomeViewController.self) { coordinator in
            return HomeViewController(
                store: try container.resolve(),
                actionCreator: try container.resolve(),
                coordinator: coordinator
            )
        }
    }

    // MARK: - Input

    private static func injectInputViewController(container: DependencyContainer) {
        container.register(
            .shared,
            type: InputViewController.Dependencies.self,
            factory: InputViewController.Dependencies.init
        )
        container.register(
            .unique,
            type: InputViewController.Store.self,
            factory: { envelope in
                InputViewController.makeStore(dependencies: try container.resolve(), envelope: envelope)
            }
        )
        container.register(
            .unique,
            type: InputViewController.ActionCreator.self,
            factory: InputViewController.ActionCreator.init
        )
        container.register(.unique, type: InputViewController.self) { (envelope: InputEnvelope, coordinator) in
            return InputViewController(
                store: try container.resolve(arguments: envelope),
                actionCreator: try container.resolve(),
                coordinator: coordinator
            )
        }
    }

    // MARK: - Login

    private static func injectLoginViewController(container: DependencyContainer) {
        container.register(
            .shared,
            type: LoginViewController.Dependencies.self,
            factory: LoginViewController.Dependencies.init
        )
        container.register(
            .unique,
            type: LoginViewController.Store.self,
            factory: { envelope in
                LoginViewController.makeStore(dependencies: try container.resolve(), envelope: envelope)
            }
        )
        container.register(
            .unique,
            type: LoginViewController.ActionCreator.self,
            factory: LoginViewController.ActionCreator.init
        )
        container.register(.unique, type: LoginViewController.self) { (envelope: LoginEnvelope, coordinator) in
            return LoginViewController(
                store: try container.resolve(arguments: envelope),
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
            factory: { envelope in
                RecipeViewController.makeStore(dependencies: try container.resolve(), envelope: envelope)
            }
        )
        container.register(
            .unique,
            type: RecipeViewController.ActionCreator.self,
            factory: RecipeViewController.ActionCreator.init
        )
        container.register(.unique, type: RecipeViewController.self) { (envelope: RecipeEnvelope, coordinator) in
            return RecipeViewController(
                store: try container.resolve(arguments: envelope),
                actionCreator: try container.resolve(),
                coordinator: coordinator
            )
        }
    }

    // MARK: - Profile

    private static func injectProfileViewController(container: DependencyContainer) {
        container.register(
            .shared,
            type: ProfileViewController.Dependencies.self,
            factory: ProfileViewController.Dependencies.init
        )
        container.register(
            .unique,
            type: ProfileViewController.Store.self,
            factory: ProfileViewController.makeStore
        )
        container.register(
            .unique,
            type: ProfileViewController.ActionCreator.self,
            factory: ProfileViewController.ActionCreator.init
        )
        container.register(.unique, type: ProfileViewController.self) { coordinator in
            return ProfileViewController(
                store: try container.resolve(),
                actionCreator: try container.resolve(),
                coordinator: coordinator
            )
        }
    }

    // MARK: - Sign Up

    private static func injectSignUpViewController(container: DependencyContainer) {
        container.register(
            .shared,
            type: SignUpViewController.Dependencies.self,
            factory: SignUpViewController.Dependencies.init
        )
        container.register(
            .unique,
            type: SignUpViewController.Store.self,
            factory: SignUpViewController.makeStore(dependencies:)
        )
        container.register(
            .unique,
            type: SignUpViewController.ActionCreator.self,
            factory: SignUpViewController.ActionCreator.init
        )
        container.register(.unique, type: SignUpViewController.self) { coordinator in
            return SignUpViewController(
                store: try container.resolve(),
                actionCreator: try container.resolve(),
                coordinator: coordinator
            )
        }
    }
}
