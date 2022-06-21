//
//  RecipeEnvelope.swift
//  
//
//  Created by Oleksii Andriushchenko on 21.06.2022.
//

import DomainModels

public struct RecipeEnvelope: Equatable {

    // MARK: - Properties

    let recipe: Recipe

    // MARK: - Lifecycle

    public init(recipe: Recipe) {
        self.recipe = recipe
    }
}
