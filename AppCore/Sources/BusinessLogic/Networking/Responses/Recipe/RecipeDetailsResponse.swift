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
    let name: String
    let rating: RatingDetailsResponse

    var domainModel: RecipeDetails {
        let recipeImageURL = AppEnvironment.current.baseURL.appendingPathComponent("files/recipe/\(imageID)")
        return RecipeDetails(
            id: Recipe.ID(rawValue: id),
            name: name,
            author: author.domainModel,
            ratingDetails: rating.domainModel,
            duration: duration,
            ingredients: ingredients.map(\.domainModel),
            instructions: instructions,
            rating: rating.domainModel
        )
    }
}
