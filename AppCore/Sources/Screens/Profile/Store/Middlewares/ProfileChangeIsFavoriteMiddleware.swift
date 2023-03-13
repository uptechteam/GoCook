//
//  ProfileChangeIsFavoriteMiddleware.swift
//  
//
//  Created by Oleksii Andriushchenko on 10.03.2023.
//

import Foundation

extension ProfileViewController {
    static func makeChangeIsFavoriteMiddleware(dependencies: Dependencies) -> Store.Middleware {
        return Store.makeMiddleware { dispatch, getState, next, action in
            let oldState = getState()
            await next(action)
            let state = getState()
            guard let recipe = state.pendingRecipe, recipe != oldState.pendingRecipe else {
                return
            }

            do {
                if recipe.isFavorite {
                    try await dependencies.recipesFacade.removeFromFavorites(recipeID: recipe.id)
                } else {
                    try await dependencies.recipesFacade.addToFavorites(recipeID: recipe.id)
                }

                await dispatch(.changeIsFavorite(.success(())))
            } catch {
                await dispatch(.changeIsFavorite(.failure(error)))
            }
        }
    }
}
