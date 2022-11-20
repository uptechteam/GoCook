//
//  CreateRecipeViewController+Injection.swift
//  
//
//  Created by Oleksii Andriushchenko on 20.11.2022.
//

import Dip

extension CreateRecipeViewController {
    public static func inject(into container: DependencyContainer) {
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

    public static func resolve(
        from container: DependencyContainer,
        coordinator: CreateRecipeCoordinating
    ) -> CreateRecipeViewController {
        try! container.resolve(arguments: coordinator)
    }
}
