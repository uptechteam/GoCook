//
//  RecipeDetails.swift
//  
//
//  Created by Oleksii Andriushchenko on 16.06.2022.
//

import Foundation

public struct RecipeDetails: Equatable {

    // MARK: - Properties

    public let id: Recipe.ID
    public let name: String
    public let author: User
    public let ratingDetails: RatingDetails
    public let duration: Int
    public let ingredients: [Ingredient]
    public let instructions: [String]
    public let rating: Int?

    // MARK: - Lifecycle

    public init(
        id: Recipe.ID,
        name: String,
        author: User,
        ratingDetails: RatingDetails,
        duration: Int,
        ingredients: [Ingredient],
        instructions: [String],
        rating: Int?
    ) {
        self.id = id
        self.name = name
        self.author = author
        self.ratingDetails = ratingDetails
        self.duration = duration
        self.ingredients = ingredients
        self.instructions = instructions
        self.rating = rating
    }
}
