//
//  RecipeDetails.swift
//  
//
//  Created by Oleksii Andriushchenko on 16.06.2022.
//

import Foundation
import Helpers

public struct RecipeDetails: Equatable {

    // MARK: - Properties

    public let author: User
    public let duration: Int
    public let id: Recipe.ID
    public let ingredients: [Ingredient]
    public let instructions: [String]
    public let name: String
    public let ratingDetails: RatingDetails
    public let recipeImageSource: ImageSource

    // MARK: - Lifecycle

    public init(
        author: User,
        duration: Int,
        id: Recipe.ID,
        ingredients: [Ingredient],
        instructions: [String],
        name: String,
        ratingDetails: RatingDetails,
        recipeImageSource: ImageSource
    ) {
        self.author = author
        self.duration = duration
        self.id = id
        self.ingredients = ingredients
        self.instructions = instructions
        self.name = name
        self.ratingDetails = ratingDetails
        self.recipeImageSource = recipeImageSource
    }
}

// MARK: - EmptyDomainModel

extension RecipeDetails: EmptyDomainModel {
    public static var empty: RecipeDetails {
        .init(
            author: User(avatar: .asset(nil), id: User.ID(rawValue: "1"), username: ""),
            duration: 0,
            id: Recipe.ID(rawValue: "1"),
            ingredients: [],
            instructions: [],
            name: "",
            ratingDetails: RatingDetails(rating: 0, reviewsCount: 0),
            recipeImageSource: .asset(nil)
        )
    }
}
