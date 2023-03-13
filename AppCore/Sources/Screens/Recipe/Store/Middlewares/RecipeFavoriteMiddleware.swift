//
//  RecipeFavoriteMiddleware.swift
//  
//
//  Created by Oleksii Andriushchenko on 24.11.2022.
//

import DomainModels
import Foundation

extension RecipeViewController {

    static func makeFavoriteMiddleware(dependencies: Dependencies) -> Store.Middleware {
        return Store.makeMiddleware { dispatch, getState, next, action in

            await next(action)
            let state = getState()

            guard case .favoriteTapped = action else {
                return
            }

            do {
                let recipeDetails: RecipeDetails
                if state.recipeDetails.isFavorite {
                    try await dependencies.recipesFacade.removeFromFavorites(recipeID: state.recipe.id)
                } else {
                    try await dependencies.recipesFacade.addToFavorites(recipeID: state.recipe.id)
                }

                await dispatch(.favorite(.success(())))
            } catch {
                await dispatch(.favorite(.failure(error)))
            }
        }
    }
}
