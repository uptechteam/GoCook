//
//  RecipesClient.swift
//  
//
//  Created by Oleksii Andriushchenko on 20.06.2022.
//

import DomainModels
import Foundation

public protocol RecipesClienting {
    func getRecipes() async throws -> [RecipeCategory]
}

public final class RecipesClient: RecipesClienting {

    // MARK: - Properties

    private let api: FeedAPI
    private let networkClient: NetworkClient

    // MARK: - Lifecycle

    public init(networkClient: NetworkClient) {
        self.api = FeedAPI(baseURL: URL(string: "http://127.0.0.1:8080")!)
        self.networkClient = networkClient
    }

    // MARK: - Public methods

    public func getRecipes() async throws -> [RecipeCategory] {
        let appRequest = try api.makeGetRecipesTarget()
        let response: [RecipeCategoryResponse] = try await networkClient.request(appRequest)
        return response.map(\.domainModel)
    }
}
