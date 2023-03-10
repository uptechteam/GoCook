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
    func getNextPage() async throws
    func observeFeed() async -> AnyPublisher<[Recipe], Never>
}

public actor RecipesFacade: RecipesFacading {

    // MARK: - Properties

    private let recipesClient: RecipesClienting
    private let recipesStorage: RecipesStoraging
    private var identifiers: [Recipe.ID]
    private let identifiersSubject: CurrentValueSubject<[Recipe.ID], Never>
    private var page: Int = 0
    private let userID: User.ID

    // MARK: - Lifecycle

    public init(userID: User.ID, recipesClient: RecipesClienting, recipesStorage: RecipesStoraging) {
        self.recipesClient = recipesClient
        self.recipesStorage = recipesStorage
        self.identifiers = []
        self.identifiersSubject = CurrentValueSubject([])
        self.userID = userID
    }

    // MARK: - Public methods

    public func getFirstPage() async throws {
        let recipes = try await recipesClient.fetchRecipes(authorID: userID, page: 0)
        self.identifiers = recipes.map(\.id)
        await self.recipesStorage.store(recipes: recipes)
        self.identifiersSubject.send(identifiers)
    }

    public func getNextPage() async throws {
        guard page > 0 else {
            return
        }

        let recipes = try await recipesClient.fetchRecipes(authorID: userID, page: page)
        if recipes.count != AppConstants.Pagination.pageSize {
            self.page = 0
        } else {
            self.page += 1
        }

        await self.recipesStorage.store(recipes: recipes)
        self.updateIdentifiers(ids: self.identifiers + recipes.map(\.id))
    }

    public func observeFeed() -> AnyPublisher<[Recipe], Never> {
        return identifiersSubject
            .mapAsync { [recipesStorage] ids in
                await recipesStorage.observeRecipes(by: ids)
            }
            .switchToLatest()
            .eraseToAnyPublisher()
    }

    private func updateIdentifiers(ids: [Recipe.ID]) {
        var uniqueRecipeIDs: [Recipe.ID] = []
        var usedRecipeIDs: Set<Recipe.ID> = Set()
        for id in ids where !usedRecipeIDs.contains(id) {
            uniqueRecipeIDs.append(id)
            usedRecipeIDs.insert(id)
        }

        self.identifiers = uniqueRecipeIDs
        self.identifiersSubject.send(self.identifiers)
    }
}
