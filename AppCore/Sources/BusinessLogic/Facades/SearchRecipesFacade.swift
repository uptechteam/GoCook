//
//  SearchRecipesFacade.swift
//  
//
//  Created by Oleksii Andriushchenko on 13.03.2023.
//

import Combine
import DomainModels
import Helpers

public protocol SearchRecipesFacading: Sendable {
    func getFirstPage(query: String, filter: RecipeFilters) async throws
    func getNextPage(query: String, filter: RecipeFilters) async throws
    func observeFeed() async -> AnyPublisher<[Recipe], Never>
}

public actor SearchRecipesFacade: SearchRecipesFacading {

    // MARK: - Properties

    private let recipesClient: RecipesClienting
    private let recipesStorage: RecipesStoraging
    private let paginator: RecipesPaginator

    // MARK: - Lifecycle

    public init(recipesClient: RecipesClienting, recipesStorage: RecipesStoraging) {
        self.recipesClient = recipesClient
        self.recipesStorage = recipesStorage
        self.paginator = RecipesPaginator()
    }

    // MARK: - Public methods

    public func getFirstPage(query: String, filter: RecipeFilters) async throws {
        await paginator.reset()
        let recipes = try await recipesClient.fetchRecipes(query: query, filters: filter, page: 0)
        guard !Task.isCancelled else {
            return
        }

        await recipesStorage.store(recipes: recipes)
        await paginator.handle(recipes: recipes)
    }

    public func getNextPage(query: String, filter: RecipeFilters) async throws {
        let page = await paginator.page
        guard page > 0 else {
            return
        }

        let recipes = try await recipesClient.fetchRecipes(query: query, filters: filter, page: page)
        guard !Task.isCancelled else {
            return
        }

        await recipesStorage.store(recipes: recipes)
        await paginator.handle(recipes: recipes)
    }

    public func observeFeed() -> AnyPublisher<[Recipe], Never> {
        return paginator.identifiersSubject
            .compactMap { $0 }
            .mapAsync { [recipesStorage] ids in
                await recipesStorage.observeRecipes(by: ids)
            }
            .switchToLatest()
            .eraseToAnyPublisher()
    }
}
