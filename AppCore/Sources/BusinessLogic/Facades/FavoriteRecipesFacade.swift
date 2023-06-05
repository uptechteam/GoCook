//
//  FavoriteRecipesFacade.swift
//  
//
//  Created by Oleksii Andriushchenko on 13.03.2023.
//

import Combine
import DomainModels
import Helpers

public protocol FavoriteRecipesFacading: Sendable {
    func getFavoriteRecipes(query: String, filters: RecipeFilters) async throws
    func observeFeed() async -> AnyPublisher<[Recipe], Never>
}

public actor FavoriteRecipesFacade: FavoriteRecipesFacading {

    // MARK: - Properties

    private let recipesClient: RecipesClienting
    private let recipesStorage: RecipesStoraging
    private var identifiers: [Recipe.ID]
    private var identifiersSubject: CurrentValueSubject<[Recipe.ID]?, Never>

    // MARK: - Lifecycle

    public init(recipesClient: RecipesClienting, recipesStorage: RecipesStoraging) {
        self.recipesClient = recipesClient
        self.recipesStorage = recipesStorage
        self.identifiers = []
        self.identifiersSubject = CurrentValueSubject(nil)
    }

    // MARK: - Public methods

    public func getFavoriteRecipes(query: String, filters: RecipeFilters) async throws {
        let recipes = try await recipesClient.fetchFavoriteRecipes(query: query, filters: filters)
        await recipesStorage.store(recipes: recipes)
        self.identifiers = recipes.map(\.id)
        self.identifiersSubject.send(self.identifiers)
    }

    public func observeFeed() -> AnyPublisher<[Recipe], Never> {
        return identifiersSubject
            .compactMap { $0 }
            .mapAsync { [recipesStorage] ids in
                await recipesStorage.observeRecipes(by: ids)
            }
            .switchToLatest()
            .eraseToAnyPublisher()
    }
}
