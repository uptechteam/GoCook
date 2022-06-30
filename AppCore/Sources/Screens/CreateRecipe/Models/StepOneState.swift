//
//  StepOneState.swift
//  
//
//  Created by Oleksii Andriushchenko on 27.06.2022.
//

import DomainModels
import Foundation

struct StepOneState: Equatable {

    // MARK: - Properties

    var recipeImageState: RecipeImageState {
        didSet {
            isRecipeImageValid = true
        }
    }
    var isRecipeImageValid: Bool = true
    var mealName: String {
        didSet {
            isMealNameValid = true
        }
    }
    var isMealNameValid: Bool = true
    var categories: Set<CategoryType> {
        didSet {
            areCategoriesValid = true
        }
    }
    var areCategoriesValid: Bool = true

    var isDataValid: Bool {
        isRecipeImageValid && isMealNameValid && areCategoriesValid
    }

    // MARK: - Public methods

    mutating func validate() {
        isRecipeImageValid = recipeImageState.uploadedImageSource != nil
        isMealNameValid = !mealName.isEmpty
        areCategoriesValid = !categories.isEmpty
    }
}

