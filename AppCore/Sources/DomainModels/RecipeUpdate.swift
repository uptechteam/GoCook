//
//  RecipeUpdate.swift
//  
//
//  Created by Oleksii Andriushchenko on 02.06.2023.
//

import Foundation

public struct RecipeUpdate: Equatable {

    // MARK: - Properties

    public let duration: Int
    public let id: Recipe.ID
    public let imageID: String
    public let ingredients: [NewIngredient]
    public let instructions: [String]
    public let name: String
    public let servings: Int
    public let tags: [CategoryType]

    // MARK: - Lifecycle

    public init(
        duration: Int,
        id: Recipe.ID,
        imageID: String,
        ingredients: [NewIngredient],
        instructions: [String],
        name: String,
        servings: Int,
        tags: [CategoryType]
    ) {
        self.duration = duration
        self.id = id
        self.imageID = imageID
        self.ingredients = ingredients
        self.instructions = instructions
        self.name = name
        self.servings = servings
        self.tags = tags
    }
}
