//
//  RecipeRateMiddleware.swift
//  
//
//  Created by Oleksii Andriushchenko on 01.12.2022.
//

import DomainModels
import Foundation

extension RecipeViewController {

    static func makeRateMiddleware(dependencies: Dependencies) -> Store.Middleware {
        return Store.makeMiddleware { dispatch, getState, next, action in

            await next(action)
            let state = getState()

            guard case .starTapped(let index) = action else {
                return
            }

            do {
                let rating = index + 1
                let recipeDetails = try await dependencies.recipesClient.rate(recipeID: state.recipe.id, rating: rating)
                await dispatch(.like(.success(recipeDetails)))
            } catch {
                await dispatch(.like(.failure(error)))
            }
        }
    }
}
