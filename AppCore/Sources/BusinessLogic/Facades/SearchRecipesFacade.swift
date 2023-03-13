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
    func getFirstPage(query: String) async throws
    func getNextPage(query: String) async throws
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

    public func getFirstPage(query: String) async throws {
        let recipes = try await recipesClient.fetchRecipes(query: query, page: 0)
        await recipesStorage.store(recipes: recipes)
        await paginator.handle(recipes: recipes)
    }

    public func getNextPage(query: String) async throws {
        let page = await paginator.page
        guard page > 0 else {
            return
        }

        let recipes = try await recipesClient.fetchRecipes(query: query, page: page)
        await recipesStorage.store(recipes: recipes)
        await paginator.handle(recipes: recipes)
    }

    public func observeFeed() -> AnyPublisher<[Recipe], Never> {
        return paginator.identifiersSubject
            .mapAsync { [recipesStorage] ids in
                await recipesStorage.observeRecipes(by: ids)
            }
            .switchToLatest()
            .eraseToAnyPublisher()
    }
}
