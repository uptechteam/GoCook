//
//  UpdateRecipeRequest.swift
//  
//
//  Created by Oleksii Andriushchenko on 02.06.2023.
//

import DomainModels
import Foundation

struct UpdateRecipeRequest: Encodable {

    // MARK: - Properties

    let duration: Int?
    let imageID: String?
    let ingredients: [IngredientRepresentable]?
    let instructions: [String]?
    let name: String?
    let servings: Int?
    let tags: [String]?

    // MARK: - Lifecycle

    init(recipe: RecipeUpdate) {
        self.duration = recipe.duration
        self.imageID = recipe.imageID
        self.ingredients = recipe.ingredients.compactMap(IngredientRepresentable.init)
        self.instructions = recipe.instructions
        self.name = recipe.name
        self.servings = recipe.servings
        self.tags = recipe.tags.map(\.name)
    }
}
