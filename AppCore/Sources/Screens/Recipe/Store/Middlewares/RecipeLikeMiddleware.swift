//
//  RecipeLikeMiddleware.swift
//  
//
//  Created by Oleksii Andriushchenko on 24.11.2022.
//

import DomainModels
import Foundation

extension RecipeViewController {

    static func makeLikeMiddleware(dependencies: Dependencies) -> Store.Middleware {
        return Store.makeMiddleware { dispatch, getState, next, action in

            await next(action)
            let state = getState()

            guard case .likeTapped = action else {
                return
            }

            do {
                let recipeDetails: RecipeDetails
                if state.recipeDetails.liked {
                    recipeDetails = try await dependencies.recipesClient.dislike(recipeID: state.recipe.id)
                } else {
                    recipeDetails = try await dependencies.recipesClient.like(recipeID: state.recipe.id)
                }

                await dispatch(.like(.success(recipeDetails)))
            } catch {
                await dispatch(.like(.failure(error)))
            }
        }
    }
}
