//
//  RecipeViewController+Injection.swift
//  
//
//  Created by Oleksii Andriushchenko on 20.11.2022.
//

import Dip
import DomainModels

extension RecipeViewController {
    public static func inject(into container: DependencyContainer) {
        container.register(
            .shared,
            type: RecipeViewController.Dependencies.self,
            factory: { (recipeID: Recipe.ID) in
                RecipeViewController.Dependencies(recipeFacade: try container.resolve(arguments: recipeID))
            }
        )
        container.register(
            .unique,
            type: RecipeViewController.Store.self,
            factory: { (envelope: RecipeEnvelope) in
                return RecipeViewController.makeStore(
                    dependencies: try container.resolve(arguments: envelope.recipe.id),
                    envelope: envelope
                )
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

    public static func resolve(
        from container: DependencyContainer,
        envelope: RecipeEnvelope,
        coordinator: RecipeCoordinating
    ) -> RecipeViewController {
        try! container.resolve(arguments: envelope, coordinator)
    }
}
