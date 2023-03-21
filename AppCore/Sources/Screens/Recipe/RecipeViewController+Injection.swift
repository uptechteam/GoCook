//
//  RecipeViewController+Injection.swift
//  
//
//  Created by Oleksii Andriushchenko on 20.11.2022.
//

import BusinessLogic

extension RecipeViewController {
    public static func resolve(
        envelope: RecipeEnvelope,
        coordinator: RecipeCoordinating
    ) -> RecipeViewController {
        RecipeViewController(
            presenter: RecipePresenter(
                recipeFacade: AppContainer.resolve(arguments: envelope.recipe.id),
                envelope: envelope
            ),
            coordinator: coordinator
        )
    }
}
