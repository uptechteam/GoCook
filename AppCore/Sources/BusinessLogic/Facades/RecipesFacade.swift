//
//  RecipesFacade.swift
//  
//
//  Created by Oleksii Andriushchenko on 10.03.2023.
//

import DomainModels

public protocol RecipesFacading: Sendable {
    func addToFavorites(recipeID: Recipe.ID) async throws
    func removeFromFavorites(recipeID: Recipe.ID) async throws
}

public actor RecipesFacade: RecipesFacading {

    // MARK: - Properties

    private let recipesClient: RecipesClienting
    private let recipesStorage: RecipesStoraging

    // MARK: - Lifecycle

    public init(recipesClient: RecipesClienting, recipesStorage: RecipesStoraging) {
        self.recipesClient = recipesClient
        self.recipesStorage = recipesStorage
    }

    // MARK: - Public methods

    public func addToFavorites(recipeID: Recipe.ID) async throws {
        let recipeDetails = try await recipesClient.addToFavorites(recipeID: recipeID)
        await recipesStorage.store(recipe: recipeDetails.recipe)
    }

    public func removeFromFavorites(recipeID: Recipe.ID) async throws {
        let recipeDetails = try await recipesClient.removeFromFavorites(recipeID: recipeID)
        await recipesStorage.store(recipe: recipeDetails.recipe)
    }   
}
