//
//  RecipesClient.swift
//  
//
//  Created by Oleksii Andriushchenko on 20.06.2022.
//

import DomainModels
import Foundation
import Helpers

public protocol RecipesClienting {
    func addToFavorites(recipeID: Recipe.ID) async throws -> RecipeDetails
    func create(recipe: NewRecipe) async throws -> Recipe
    func edit(recipe: RecipeUpdate) async throws -> Recipe
    func fetchFavoriteRecipes(query: String, filters: RecipeFilters) async throws -> [Recipe]
    func fetchFeed() async throws -> [RecipeCategory]
    func fetchRecipeDetails(id: Recipe.ID) async throws -> RecipeDetails
    func fetchRecipes(authorID: User.ID, page: Int) async throws -> [Recipe]
    func fetchRecipes(query: String, filters: RecipeFilters, page: Int) async throws -> [Recipe]
    func rate(recipeID: Recipe.ID, rating: Int) async throws -> RecipeDetails
    func removeFromFavorites(recipeID: Recipe.ID) async throws -> RecipeDetails
}

public final class RecipesClient: RecipesClienting {

    // MARK: - Properties

    private let recipesAPI: RecipesAPI
    private let networkClient: NetworkClient

    // MARK: - Lifecycle

    public init(networkClient: NetworkClient) {
        self.recipesAPI = RecipesAPI(baseURL: AppEnvironment.current.baseURL)
        self.networkClient = networkClient
    }

    // MARK: - Public methods

    public func addToFavorites(recipeID: Recipe.ID) async throws -> RecipeDetails {
        let request = try recipesAPI.makePostAddToFavoritesRequest(recipeID: recipeID)
        let response: RecipeDetailsResponse = try await networkClient.execute(request)
        return response.domainModel
    }

    public func create(recipe: NewRecipe) async throws -> Recipe {
        let request = try recipesAPI.makePostRecipeRequest(recipe: recipe)
        let response: RecipeResponse = try await networkClient.execute(request)
        return response.domainModel
    }

    public func edit(recipe: RecipeUpdate) async throws -> Recipe {
        let request = try recipesAPI.makePutRecipeRequest(recipe: recipe)
        let response: RecipeResponse = try await networkClient.execute(request)
        return response.domainModel
    }

    public func fetchFavoriteRecipes(query: String, filters: RecipeFilters) async throws -> [Recipe] {
        let request = try recipesAPI.makeGetFavoriteRecipesRequest(query: query, filters: filters)
        let response: [RecipeResponse] = try await networkClient.execute(request)
        return response.map(\.domainModel)
    }

    public func fetchFeed() async throws -> [RecipeCategory] {
        let request = try recipesAPI.makeGetFeedRequest()
        let response: [RecipeCategoryResponse] = try await networkClient.execute(request)
        return try response.map { try $0.getDomainModel() }
    }

    public func fetchRecipeDetails(id: Recipe.ID) async throws -> RecipeDetails {
        let request = try recipesAPI.makeGetRecipeRequest(id: id)
        let response: RecipeDetailsResponse = try await networkClient.execute(request)
        return response.domainModel
    }

    public func fetchRecipes(authorID: User.ID, page: Int) async throws -> [Recipe] {
        let request = try recipesAPI.makeGetRecipesRequest(authorID: authorID, page: page)
        let response: [RecipeResponse] = try await networkClient.execute(request)
        return response.map(\.domainModel)
    }

    public func fetchRecipes(query: String, filters: RecipeFilters, page: Int) async throws -> [Recipe] {
        let request = try recipesAPI.makeGetRecipesRequest(query: query, filters: filters, page: page)
        let response: [RecipeResponse] = try await networkClient.execute(request)
        return response.map(\.domainModel)
    }

    public func rate(recipeID: Recipe.ID, rating: Int) async throws -> RecipeDetails {
        let request = try recipesAPI.makePostRateRequest(recipeID: recipeID, rating: rating)
        let response: RecipeDetailsResponse = try await networkClient.execute(request)
        return response.domainModel
    }

    public func removeFromFavorites(recipeID: Recipe.ID) async throws -> RecipeDetails {
        let request = try recipesAPI.makeDeleteRemoveFromFavoritesRequest(recipeID: recipeID)
        let response: RecipeDetailsResponse = try await networkClient.execute(request)
        return response.domainModel
    }
}
