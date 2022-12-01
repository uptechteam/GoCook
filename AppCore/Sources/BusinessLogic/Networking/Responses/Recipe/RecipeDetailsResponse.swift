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
    let liked: Bool
    let name: String
    let rating: RatingDetailsResponse
    let ratingByUser: Int
    let servings: Int

    var domainModel: RecipeDetails {
        let recipeImageURL = AppEnvironment.current.baseURL.appendingPathComponent("files/recipe/\(imageID)")
        return RecipeDetails(
            author: author.domainModel,
            duration: duration,
            id: Recipe.ID(rawValue: id),
            ingredients: ingredients.map(\.domainModel),
            instructions: instructions,
            liked: liked,
            name: name,
            rating: ratingByUser,
            ratingDetails: rating.domainModel,
            recipeImageSource: .remote(url: recipeImageURL),
            servingsCount: servings
        )
    }
}
