//
//  CreateRecipeUploadMiddleware.swift
//  
//
//  Created by Oleksii Andriushchenko on 01.07.2022.
//

import DomainModels
import Foundation

extension CreateRecipeViewController {

    static func makeUploadMiddleware(dependencies: Dependencies) -> Store.Middleware {
        return Store.makeMiddleware { dispatch, getState, next, action in

            await next(action)
            let state = getState()

            guard case .finishTapped = action else {
                return
            }

            let newRecipe = NewRecipe(
                duration: state.stepThreeState.cookingTime ?? 0,
                imageID: state.stepOneState.recipeImageState.imageID ?? "",
                ingredients: state.stepTwoState.ingredients,
                instructions: state.stepThreeState.instructions,
                name: state.stepOneState.mealName,
                servings: state.stepTwoState.numberOfServings ?? 0,
                tags: Array(state.stepOneState.categories)
            )

            do {
                _ = try await dependencies.recipesClient.upload(newRecipe: newRecipe)
                await dispatch(.uploadRecipe(.success(())))
            } catch {
                await dispatch(.uploadRecipe(.failure(error)))
            }
        }
    }
}
