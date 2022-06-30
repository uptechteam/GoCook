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
    func getRecipes() async throws -> [RecipeCategory]
    func uploadNewRecipe() async throws -> Recipe
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

    public func getRecipes() async throws -> [RecipeCategory] {
        let appRequest = try feedAPI.makeGetRecipesTarget()
        let response: [RecipeCategoryResponse] = try await networkClient.request(appRequest)
        return response.map(\.domainModel)
    }

    public func uploadNewRecipe() async throws -> Recipe {
        let appRequest = try recipesAPI.makePostRecipeTarget(request: fatalError())
        let response: RecipeResponse = try await networkClient.request(appRequest)
        return response.domainModel
    }
}
