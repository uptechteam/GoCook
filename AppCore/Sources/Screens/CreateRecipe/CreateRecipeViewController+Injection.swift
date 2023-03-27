//
//  CreateRecipeViewController+Injection.swift
//  
//
//  Created by Oleksii Andriushchenko on 20.11.2022.
//

import BusinessLogic

extension CreateRecipeViewController {
    public static func resolve(coordinator: CreateRecipeCoordinating) -> CreateRecipeViewController {
        return CreateRecipeViewController(
            presenter: CreateRecipePresenter(
                fileClient: AppContainer.resolve(),
                keyboardManager: AppContainer.resolve(),
                recipesClient: AppContainer.resolve()
            ),
            coordinator: coordinator
        )
    }
}
