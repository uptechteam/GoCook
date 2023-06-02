//
//  ManageRecipeStepThreeState.swift
//  
//
//  Created by Oleksii Andriushchenko on 30.06.2022.
//

import DomainModels

extension ManageRecipePresenter {
    struct StepThreeState: Equatable {

        // MARK: - Properties

        var cookingTime: Int?
        var isCookingTimeValid = true
        var instructions: [String]
        var areInstructionsValid = true

        var isDataValid: Bool {
            isCookingTimeValid && areInstructionsValid
        }

        // MARK: - Lifecycle

        init(recipe: RecipeDetails?) {
            self.cookingTime = recipe?.duration
            self.instructions = recipe?.instructions ?? [""]
        }

        // MARK: - Public methods

        mutating func validate() {
            isCookingTimeValid = cookingTime.flatMap { $0 > 0} ?? false
            areInstructionsValid = !instructions.isEmpty && instructions.allSatisfy { !$0.isEmpty }
        }
    }
}
