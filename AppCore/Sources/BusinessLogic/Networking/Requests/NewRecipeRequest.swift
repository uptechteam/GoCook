//
//  NewRecipeRequest.swift
//  
//
//  Created by Oleksii Andriushchenko on 30.06.2022.
//

import DomainModels
import Foundation

struct NewRecipeRequest: Encodable {

    // MARK: - Properties

    let duration: Int
    let imageID: String
    let ingredients: [IngredientRepresentable]
    let instructions: [String]
    let name: String
    let servings: Int
    let tags: [String]

    // MARK: - Lifecycle

    init(newRecipe: NewRecipe) {
        self.duration = newRecipe.duration
        self.imageID = newRecipe.imageID
        self.ingredients = newRecipe.ingredients.compactMap(IngredientRepresentable.init)
        self.instructions = newRecipe.instructions
        self.name = newRecipe.name
        self.servings = newRecipe.servings
        self.tags = newRecipe.tags.map(\.name)
    }
}
