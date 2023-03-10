//
//  RecipesFacade.swift
//  
//
//  Created by Oleksii Andriushchenko on 10.03.2023.
//

import Combine
import DomainModels
import Helpers

public protocol RecipesFacading: Sendable {
    func getFirstPage() async throws
    func observeFeed() async -> AnyPublisher<[Recipe], Never>
}

public actor RecipesFacade: RecipesFacading {

    // MARK: - Properties

    private let recipesClient: RecipesClienting
    private let recipesStorage: RecipesStoraging
    private var identifiers: [Recipe.ID]
    private let identifiersSubject: CurrentValueSubject<[Recipe.ID], Never>

    // MARK: - Lifecycle

    public init(recipesClient: RecipesClienting, recipesStorage: RecipesStoraging) {
        self.recipesClient = recipesClient
        self.recipesStorage = recipesStorage
        self.identifiers = []
        self.identifiersSubject = CurrentValueSubject([])
    }

    // MARK: - Public methods

    public func getFirstPage() async throws {
        let recipes = try await recipesClient.fetchRecipes(query: "")
        self.identifiers = recipes.map(\.id)
        await self.recipesStorage.store(recipes: recipes)
        self.identifiersSubject.send(identifiers)
    }

    public func observeFeed() -> AnyPublisher<[Recipe], Never> {
        return identifiersSubject
            .flatMapAsync { [recipesStorage] ids in
                await recipesStorage.observeRecipes(by: ids)
            }
            .eraseToAnyPublisher()
    }
}
