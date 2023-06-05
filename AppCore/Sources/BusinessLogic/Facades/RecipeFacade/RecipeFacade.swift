//
//  RecipeFacade.swift
//  
//
//  Created by Oleksii Andriushchenko on 15.03.2023.
//

import Combine
import DomainModels

public protocol RecipeFacading: Sendable {
    func addToFavorites() async throws
    func observeRecipe() async -> AnyPublisher<RecipeDetails, Never>
    func rate(rating: Int) async throws
    func refreshRecipe() async throws
    func removeFromFavorites() async throws
}

public actor RecipeFacade: RecipeFacading {

    // MARK: - Properties

    private let recipesClient: RecipesClienting
    private let recipesStorage: RecipesStoraging
    private var recipeDetailsSubject: CurrentValueSubject<RecipeDetails?, Never>
    private let recipeID: Recipe.ID

    // MARK: - Lifecycle

    public init(recipeID: Recipe.ID, recipesClient: RecipesClienting, recipesStorage: RecipesStoraging) {
        self.recipesClient = recipesClient
        self.recipesStorage = recipesStorage
        self.recipeDetailsSubject = CurrentValueSubject(nil)
        self.recipeID = recipeID
    }

    // MARK: - Public methods

    public func addToFavorites() async throws {
        let recipeDetails = try await recipesClient.addToFavorites(recipeID: recipeID)
        await recipesStorage.store(recipe: recipeDetails.recipe)
        recipeDetailsSubject.send(recipeDetails)
    }

    public func observeRecipe() async -> AnyPublisher<RecipeDetails, Never> {
        return recipeDetailsSubject
            .compactMap { $0 }
            .eraseToAnyPublisher()
    }

    public func rate(rating: Int) async throws {
        let recipeDetails = try await recipesClient.rate(recipeID: recipeID, rating: rating)
        await recipesStorage.store(recipe: recipeDetails.recipe)
        recipeDetailsSubject.send(recipeDetails)
    }

    public func refreshRecipe() async throws {
        let recipeDetails = try await recipesClient.fetchRecipeDetails(id: recipeID)
        recipeDetailsSubject.send(recipeDetails)
    }

    public func removeFromFavorites() async throws {
        let recipeDetails = try await recipesClient.removeFromFavorites(recipeID: recipeID)
        await recipesStorage.store(recipe: recipeDetails.recipe)
        recipeDetailsSubject.send(recipeDetails)
    }
}
