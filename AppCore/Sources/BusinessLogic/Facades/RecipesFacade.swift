//
//  RecipesFacade.swift
//  
//
//  Created by Oleksii Andriushchenko on 10.03.2023.
//

import DomainModels

public protocol RecipesFacading: Sendable {
    func addToFavorites(recipeID: Recipe.ID) async throws
    func create(recipe: NewRecipe) async throws
    func edit(recipe: RecipeUpdate) async throws
    func rate(recipeID: Recipe.ID, rating: Int) async throws
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

    public func create(recipe: NewRecipe) async throws {
        let createdRecipe = try await recipesClient.create(recipe: recipe)
        await recipesStorage.store(recipe: createdRecipe)
    }

    public func edit(recipe: RecipeUpdate) async throws {
        let editedRecipe = try await recipesClient.edit(recipe: recipe)
        await recipesStorage.store(recipe: editedRecipe)
    }

    public func rate(recipeID: Recipe.ID, rating: Int) async throws {
        let recipeDetails = try await recipesClient.rate(recipeID: recipeID, rating: rating)
        await recipesStorage.store(recipe: recipeDetails.recipe)
    }

    public func removeFromFavorites(recipeID: Recipe.ID) async throws {
        let recipeDetails = try await recipesClient.removeFromFavorites(recipeID: recipeID)
        await recipesStorage.store(recipe: recipeDetails.recipe)
    }
}
