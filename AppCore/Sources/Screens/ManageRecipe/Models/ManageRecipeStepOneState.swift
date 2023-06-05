//
//  StepOneState.swift
//  
//
//  Created by Oleksii Andriushchenko on 27.06.2022.
//

import DomainModels
import Foundation

extension ManageRecipePresenter {
    struct StepOneState: Equatable {

        // MARK: - Properties

        var recipeImageState: ImageState
        var isRecipeImageValid: Bool = true
        var mealName: String
        var isMealNameValid: Bool = true
        var categories: Set<CategoryType>
        var areCategoriesValid: Bool = true

        var isDataValid: Bool {
            isRecipeImageValid && isMealNameValid && areCategoriesValid
        }

        var isEmpty: Bool {
            recipeImageState == .empty && mealName.isEmpty && categories.isEmpty
        }

        // MARK: - Lifecycle

        init(recipe: RecipeDetails?) {
            self.recipeImageState = recipe.flatMap { ImageState.existing($0.recipeImageSource) } ?? .empty
            self.mealName = recipe?.name ?? ""
            self.categories = Set(recipe?.tags ?? [])
        }

        // MARK: - Public methods

        mutating func validate() {
            isRecipeImageValid = recipeImageState.uploadedImageSource != nil
            isMealNameValid = !mealName.isEmpty
            areCategoriesValid = !categories.isEmpty
        }
    }
}
