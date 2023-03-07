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
                    recipeDetails = try await dependencies.recipesClient.removeFromFavorites(recipeID: state.recipe.id)
                } else {
                    recipeDetails = try await dependencies.recipesClient.addToFavorites(recipeID: state.recipe.id)
                }

                await dispatch(.favorite(.success(recipeDetails)))
            } catch {
                await dispatch(.favorite(.failure(error)))
            }
        }
    }
}
