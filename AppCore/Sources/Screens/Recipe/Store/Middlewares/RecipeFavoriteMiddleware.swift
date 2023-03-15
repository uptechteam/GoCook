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
                if state.recipeDetails.isFavorite {
                    try await dependencies.recipeFacade.removeFromFavorites()
                } else {
                    try await dependencies.recipeFacade.addToFavorites()
                }

                await dispatch(.favorite(.success(())))
            } catch {
                await dispatch(.favorite(.failure(error)))
            }
        }
    }
}
