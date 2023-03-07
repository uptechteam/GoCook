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
    public let isFavorite: Bool
    public let name: String
    public var rating: Int?
    public let ratingDetails: RatingDetails
    public let recipeImageSource: ImageSource
    public let servingsCount: Int

    // MARK: - Lifecycle

    public init(
        author: User,
        duration: Int,
        id: Recipe.ID,
        ingredients: [Ingredient],
        instructions: [String],
        isFavorite: Bool,
        name: String,
        rating: Int?,
        ratingDetails: RatingDetails,
        recipeImageSource: ImageSource,
        servingsCount: Int
    ) {
        self.author = author
        self.duration = duration
        self.id = id
        self.ingredients = ingredients
        self.instructions = instructions
        self.isFavorite = isFavorite
        self.name = name
        self.rating = rating
        self.ratingDetails = ratingDetails
        self.recipeImageSource = recipeImageSource
        self.servingsCount = servingsCount
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
            isFavorite: false,
            name: "",
            rating: 0,
            ratingDetails: RatingDetails(rating: 0, reviewsCount: 0),
            recipeImageSource: .asset(nil),
            servingsCount: 0
        )
    }
}
