//
//  RecipeGetDetailsMiddleware.swift
//  
//
//  Created by Oleksii Andriushchenko on 27.11.2022.
//

import Foundation

extension RecipeViewController {

    static func makeGetRecipeDetailsMiddleware(dependencies: Dependencies) -> Store.Middleware {
        return Store.makeMiddleware { dispatch, getState, next, action in

            let oldState = getState()
            await next(action)
            let state = getState()

            guard state.recipeDetails.isLoading && !oldState.recipeDetails.isLoading else {
                return
            }

            do {
                try await dependencies.recipeFacade.refreshRecipe()
                await dispatch(.getRecipeDetails(.success(())))
            } catch {
                await dispatch(.getRecipeDetails(.failure(error)))
            }
        }
    }
}
