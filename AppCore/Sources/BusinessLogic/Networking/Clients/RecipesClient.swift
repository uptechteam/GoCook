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
    func dislike(recipeID: Recipe.ID) async throws -> RecipeDetails
    func fetchFavoriteRecipes() async throws -> [Recipe]
    func fetchFeed() async throws -> [RecipeCategory]
    func fetchRecipeDetails(id: Recipe.ID) async throws -> RecipeDetails
    func fetchRecipes(query: String) async throws -> [Recipe]
    func like(recipeID: Recipe.ID) async throws -> RecipeDetails
    func rate(recipeID: Recipe.ID, rating: Int) async throws -> RecipeDetails
    func upload(newRecipe: NewRecipe) async throws -> Recipe
}

public final class RecipesClient: RecipesClienting {

    // MARK: - Properties

    private let feedAPI: FeedAPI
    private let recipesAPI: RecipesAPI
    private let networkClient: NetworkClient

    // MARK: - Lifecycle

    public init(networkClient: NetworkClient) {
        self.feedAPI = FeedAPI(baseURL: AppEnvironment.current.baseURL)
        self.recipesAPI = RecipesAPI(baseURL: AppEnvironment.current.baseURL)
        self.networkClient = networkClient
    }

    // MARK: - Public methods

    public func dislike(recipeID: Recipe.ID) async throws -> RecipeDetails {
        let request = try recipesAPI.makeDeleteDislikeRequest(recipeID: recipeID)
        let response: RecipeDetailsResponse = try await networkClient.execute(request)
        return response.domainModel
    }

    public func fetchFavoriteRecipes() async throws -> [Recipe] {
        let request = try recipesAPI.makeGetFavoriteRecipesRequest()
        let response: [RecipeResponse] = try await networkClient.execute(request)
        return response.map(\.domainModel)
    }

    public func fetchFeed() async throws -> [RecipeCategory] {
        let appRequest = try feedAPI.makeGetRecipesRequest()
        let response: [RecipeCategoryResponse] = try await networkClient.execute(appRequest)
        return try response.map { try $0.getDomainModel() }
    }

    public func fetchRecipeDetails(id: Recipe.ID) async throws -> RecipeDetails {
        let request = try recipesAPI.makeGetRecipeRequest(id: id)
        let response: RecipeDetailsResponse = try await networkClient.execute(request)
        return response.domainModel
    }

    public func fetchRecipes(query: String) async throws -> [Recipe] {
        let appRequest = try recipesAPI.makeGetRecipesRequest(query: query)
        let response: [RecipeResponse] = try await networkClient.execute(appRequest)
        return response.map(\.domainModel)
    }

    public func like(recipeID: Recipe.ID) async throws -> RecipeDetails {
        let request = try recipesAPI.makePostLikeRequest(recipeID: recipeID)
        let response: RecipeDetailsResponse = try await networkClient.execute(request)
        return response.domainModel
    }

    public func rate(recipeID: Recipe.ID, rating: Int) async throws -> RecipeDetails {
        let request = try recipesAPI.makePostRateRequest(recipeID: recipeID, rating: rating)
        let response: RecipeDetailsResponse = try await networkClient.execute(request)
        return response.domainModel
    }

    public func upload(newRecipe: NewRecipe) async throws -> Recipe {
        let appRequest = try recipesAPI.makePostRecipeRequest(request: NewRecipeRequest(newRecipe: newRecipe))
        let response: RecipeResponse = try await networkClient.execute(appRequest)
        return response.domainModel
    }
}
