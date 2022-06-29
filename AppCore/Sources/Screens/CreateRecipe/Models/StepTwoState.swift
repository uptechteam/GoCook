//
//  StepTwoState.swift
//  
//
//  Created by Oleksii Andriushchenko on 28.06.2022.
//

import DomainModels
import Foundation

struct StepTwoState: Equatable {

    // MARK: - Properties

    var numberOfServings: Int? {
        didSet {
            isNumberOfServingsValid = true
        }
    }
    var isNumberOfServingsValid: Bool = true
    var ingredients: [NewIngredient] {
        didSet {
            areIngredientsValid = true
        }
    }
    var areIngredientsValid: Bool = true

    var isDataValid: Bool {
        isNumberOfServingsValid && areIngredientsValid
    }

    // MARK: - Public methods

    mutating func validate() {
        isNumberOfServingsValid = numberOfServings.flatMap { $0 > 0 } ?? false
        areIngredientsValid = ingredients.allSatisfy(\.isValid)
    }
}

struct NewIngredient: Equatable {
    let id: String
    let name: String
    let unit: IngredientUnit

    var isValid: Bool {
        !name.isEmpty
    }
}
