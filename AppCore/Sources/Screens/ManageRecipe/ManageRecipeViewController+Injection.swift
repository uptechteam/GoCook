//
//  ManageRecipeViewController+Injection.swift
//  
//
//  Created by Oleksii Andriushchenko on 20.11.2022.
//

import BusinessLogic

extension ManageRecipeViewController {
    public static func resolve(
        envelope: ManageRecipeEnvelope,
        coordinator: ManageRecipeCoordinating
    ) -> ManageRecipeViewController {
        return ManageRecipeViewController(
            presenter: ManageRecipePresenter(
                envelope: envelope,
                fileClient: AppContainer.resolve(),
                keyboardManager: AppContainer.resolve(),
                recipesFacade: AppContainer.resolve()
            ),
            coordinator: coordinator
        )
    }
}
