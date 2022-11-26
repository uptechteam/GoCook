//
//  RecipeLikeMiddleware.swift
//  
//
//  Created by Oleksii Andriushchenko on 24.11.2022.
//

import Foundation

extension RecipeViewController {

    static func makeLikeMiddleware(dependencies: Dependencies) -> Store.Middleware {
        return Store.makeMiddleware { _, getState, next, action in

            await next(action)
            let state = getState()

            guard case .likeTapped = action else {
                return
            }

            do {
                let _ = try await dependencies.recipesClient.likeRecipe(id: state.recipe.id)
            } catch {

            }
        }
    }
}
