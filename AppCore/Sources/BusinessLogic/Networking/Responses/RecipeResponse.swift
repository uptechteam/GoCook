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
    let avatarURL: String
    let id: String
    let name: String
    let rating: Double

    var domainModel: Recipe {
        Recipe(
            id: .init(rawValue: id),
            name: name,
            recipeImageSource: URL(string: avatarURL).flatMap(ImageSource.remote(url:)) ?? .asset(nil),
            rating: rating
        )
    }
}
