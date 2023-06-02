//
//  CreateRecipeState.swift
//  
//
//  Created by Oleksii Andriushchenko on 27.03.2023.
//

import DomainModels
import Helpers

extension CreateRecipePresenter {

    // MARK: - State

    struct State: Equatable {

        // MARK: - Properties

        var isUploadingRecipe: Bool
        var step: Int
        var stepOneState: StepOneState
        var stepTwoState: StepTwoState
        var stepThreeState: StepThreeState
        var alert: AnyIdentifiable<Alert>?
        var route: AnyIdentifiable<Route>?

        // MARK: - Public methods

        static func makeInitialState() -> State {
            return State(
                isUploadingRecipe: false,
                step: 0,
                stepOneState: StepOneState(recipeImageState: .empty, mealName: "", categories: Set()),
                stepTwoState: StepTwoState(ingredients: [.makeNewIngredient()]),
                stepThreeState: StepThreeState(instructions: [""]),
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
