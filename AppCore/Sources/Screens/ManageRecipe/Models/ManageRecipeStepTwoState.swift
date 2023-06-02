//
//  StepTwoState.swift
//  
//
//  Created by Oleksii Andriushchenko on 28.06.2022.
//

import DomainModels
import Foundation

extension ManageRecipePresenter {
    struct StepTwoState: Equatable {

        // MARK: - Properties

        var numberOfServings: Int?
        var isNumberOfServingsValid: Bool = true
        var ingredients: [NewIngredient]
        var areIngredientsValid: Bool = true

        var isDataValid: Bool {
            isNumberOfServingsValid && areIngredientsValid
        }

        // MARK: - Lifecycle

        init(recipe: RecipeDetails?) {
            self.numberOfServings = recipe?.servingsCount
            self.ingredients = recipe?.ingredients.map(NewIngredient.init) ?? [.makeNewIngredient()]
        }

        // MARK: - Public methods

        mutating func validate() {
            isNumberOfServingsValid = numberOfServings.flatMap { $0 > 0 } ?? false
            areIngredientsValid = ingredients.allSatisfy(\.isValid)
        }
    }
}
