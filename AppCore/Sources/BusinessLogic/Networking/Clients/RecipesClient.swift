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
}

public final class RecipesClient: RecipesClienting {

    // MARK: - Properties

    private let api: FeedAPI
    private let networkClient: NetworkClient

    // MARK: - Lifecycle

    public init(networkClient: NetworkClient) {
        self.api = FeedAPI(baseURL: AppEnvironment.current.baseURL)
        self.networkClient = networkClient
    }

    // MARK: - Public methods

    public func getRecipes() async throws -> [RecipeCategory] {
        let appRequest = try api.makeGetRecipesTarget()
        let response: [RecipeCategoryResponse] = try await networkClient.request(appRequest)
        return response.map(\.domainModel)
    }
}
