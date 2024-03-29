//
//  RecipeDetailsResponse.swift
//  
//
//  Created by Oleksii Andriushchenko on 24.11.2022.
//

import DomainModels
import Foundation
import Helpers

public struct RecipeDetailsResponse: Decodable {
    let author: UserResponse
    let duration: Int
    let id: String
    let imageID: String
    let ingredients: [IngredientRepresentable]
    let instructions: [String]
    let isFavorite: Bool
    let name: String
    let rating: RatingDetailsResponse
    let ratingByUser: Int?
    let servings: Int
    let tags: [String]

    var domainModel: RecipeDetails {
        let recipeImageURL = AppSettings.current.baseURL.appendingPathComponent("files/recipe/\(imageID)")
        return RecipeDetails(
            author: author.domainModel,
            duration: duration,
            id: Recipe.ID(rawValue: id),
            ingredients: ingredients.map(\.domainModel),
            instructions: instructions,
            isFavorite: isFavorite,
            name: name,
            rating: ratingByUser,
            ratingDetails: rating.domainModel,
            recipeImageSource: .remote(url: recipeImageURL),
            servingsCount: servings,
            tags: tags.compactMap(CategoryType.init(name:))
        )
    }
}
