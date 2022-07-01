//
//  NewRecipe.swift
//  
//
//  Created by Oleksii Andriushchenko on 30.06.2022.
//

import Foundation

public struct NewRecipe: Equatable {

    // MARK: - Properties

    public let duration: Int
    public let imageID: String
    public let ingredients: [NewIngredient]
    public let instructions: [String]
    public let name: String
    public let servings: Int
    public let tags: [CategoryType]

    // MARK: - Lifecycle

    public init(
        duration: Int,
        imageID: String,
        ingredients: [NewIngredient],
        instructions: [String],
        name: String,
        servings: Int,
        tags: [CategoryType]
    ) {
        self.duration = duration
        self.imageID = imageID
        self.ingredients = ingredients
        self.instructions = instructions
        self.name = name
        self.servings = servings
        self.tags = tags
    }
}
