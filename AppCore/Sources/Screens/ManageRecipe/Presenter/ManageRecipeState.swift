//
//  ManageRecipeState.swift
//  
//
//  Created by Oleksii Andriushchenko on 27.03.2023.
//

import DomainModels
import Helpers

extension ManageRecipePresenter {

    // MARK: - State

    struct State: Equatable {

        // MARK: - Properties

        var isUploadingRecipe: Bool
        var recipeID: Recipe.ID?
        var step: Int
        var stepOneState: StepOneState
        var stepTwoState: StepTwoState
        var stepThreeState: StepThreeState
        var alert: AnyIdentifiable<Alert>?
        var route: AnyIdentifiable<Route>?

        func getNewRecipe() -> NewRecipe {
            return NewRecipe(
                duration: stepThreeState.cookingTime ?? 0,
                imageID: stepOneState.recipeImageState.imageID ?? "",
                ingredients: stepTwoState.ingredients,
                instructions: stepThreeState.instructions,
                name: stepOneState.mealName,
                servings: stepTwoState.numberOfServings ?? 0,
                tags: Array(stepOneState.categories)
            )
        }

        func getRecipeUpdate(recipeID: Recipe.ID) -> RecipeUpdate {
            return RecipeUpdate(
                duration: stepThreeState.cookingTime ?? 0,
                id: recipeID,
                imageID: stepOneState.recipeImageState.imageID ?? "",
                ingredients: stepTwoState.ingredients,
                instructions: stepThreeState.instructions,
                name: stepOneState.mealName,
                servings: stepTwoState.numberOfServings ?? 0,
                tags: Array(stepOneState.categories)
            )
        }

        // MARK: - Public methods

        static func makeInitialState(envelope: ManageRecipeEnvelope) -> State {
            return State(
                isUploadingRecipe: false,
                recipeID: envelope.recipe?.id,
                step: 0,
                stepOneState: StepOneState(recipe: envelope.recipe),
                stepTwoState: StepTwoState(recipe: envelope.recipe),
                stepThreeState: StepThreeState(recipe: envelope.recipe),
                alert: nil,
                route: nil
            )
        }
    }

    // MARK: - Route

    enum Alert {
        case deleteProgress
        case imagePicker(isDeleteButtonVisible: Bool)
    }

    enum Route {
        case close
        case inputTapped(InputDetails)
    }
}
