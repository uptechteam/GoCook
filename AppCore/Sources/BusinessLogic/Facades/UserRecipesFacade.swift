//
//  UserRecipesFacade.swift
//  
//
//  Created by Oleksii Andriushchenko on 10.03.2023.
//

import Combine
import DomainModels
import Helpers

public protocol UserRecipesFacading: Sendable {
    func getFirstPage() async throws
    func getNextPage() async throws
    func observeFeed() async -> AnyPublisher<[Recipe], Never>
}

public actor UserRecipesFacade: UserRecipesFacading {

    // MARK: - Properties

    private let recipesClient: RecipesClienting
    private let recipesStorage: RecipesStoraging
    private let paginator: RecipesPaginator
    private let userID: User.ID

    // MARK: - Lifecycle

    public init(userID: User.ID, recipesClient: RecipesClienting, recipesStorage: RecipesStoraging) {
        self.recipesClient = recipesClient
        self.recipesStorage = recipesStorage
        self.paginator = RecipesPaginator()
        self.userID = userID
    }

    // MARK: - Public methods

    public func getFirstPage() async throws {
        let recipes = try await recipesClient.fetchRecipes(authorID: userID, page: 0)
        await recipesStorage.store(recipes: recipes)
        await paginator.handle(recipes: recipes)
    }

    public func getNextPage() async throws {
        let page = await paginator.page
        guard page > 0 else {
            return
        }

        let recipes = try await recipesClient.fetchRecipes(authorID: userID, page: page)
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
