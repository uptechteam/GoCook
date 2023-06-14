//
//  RecipeResponse.swift
//  
//
//  Created by Oleksii Andriushchenko on 20.06.2022.
//

import DomainModels
import Foundation
import Helpers

public struct RecipeResponse: Decodable {
    let id: String
    let imageID: String
    let isFavorite: Bool
    let name: String
    let rating: Double

    var domainModel: Recipe {
        let recipeImageURL = AppSettings.current.baseURL.appendingPathComponent("files/recipe/\(imageID)")
        return Recipe(
            id: .init(rawValue: id),
            isFavorite: isFavorite,
            name: name,
            recipeImageSource: ImageSource.remote(url: recipeImageURL),
            rating: rating
        )
    }
}
