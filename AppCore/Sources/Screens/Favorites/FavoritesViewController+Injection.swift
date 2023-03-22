//
//  FavoritesViewController+Injection.swift
//  
//
//  Created by Oleksii Andriushchenko on 20.11.2022.
//

import BusinessLogic
import DomainModels

extension FavoritesViewController {
    public static func resolve(coordinator: FavoritesCoordinating) -> FavoritesViewController {
        return FavoritesViewController(
            presenter: FavoritesPresenter(
                favoriteRecipesFacade: AppContainer.resolve(),
                filtersFacade: AppContainer.resolve(tag: FiltersFacadeTag.favorites),
                recipesFacade: AppContainer.resolve()
            ),
            coordinator: coordinator
        )
    }
}
