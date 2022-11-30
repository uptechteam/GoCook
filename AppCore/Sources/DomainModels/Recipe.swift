//
//  Recipe.swift
//  
//
//  Created by Oleksii Andriushchenko on 15.06.2022.
//

import Helpers

public struct Recipe: Equatable {

    // MARK: - Properties

    public typealias ID = Tagged<Recipe, String>

    public let id: ID
    public let isFavorite: Bool
    public let name: String
    public let recipeImageSource: ImageSource
    public let rating: Double

    // MARK: - Lifecycle

    public init(id: Recipe.ID, isFavorite: Bool, name: String, recipeImageSource: ImageSource, rating: Double) {
        self.id = id
        self.isFavorite = isFavorite
        self.name = name
        self.recipeImageSource = recipeImageSource
        self.rating = rating
    }
}
