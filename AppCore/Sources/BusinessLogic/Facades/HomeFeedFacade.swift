//
//  HomeFeedFacade.swift
//  
//
//  Created by Oleksii Andriushchenko on 13.03.2023.
//

import Combine
import DomainModels
import Helpers

public protocol HomeFeedFacading: Sendable {
    func getFeed() async throws
    func observeFeed() async -> AnyPublisher<[RecipeCategory], Never>
}

public actor HomeFeedFacade: HomeFeedFacading {

    // MARK: - Properties

    private let recipesClient: RecipesClienting
    private let recipesStorage: RecipesStoraging
    private var feed: [RecipeCategory]
    private var identifiers: [Recipe.ID]
    private var identifiersSubject: CurrentValueSubject<[Recipe.ID]?, Never>

    // MARK: - Lifecycle

    public init(recipesClient: RecipesClienting, recipesStorage: RecipesStoraging) {
        self.recipesClient = recipesClient
        self.recipesStorage = recipesStorage
        self.feed = []
        self.identifiers = []
        self.identifiersSubject = CurrentValueSubject(nil)
    }

    // MARK: - Public methods

    public func getFeed() async throws {
        let categories = try await recipesClient.fetchFeed()
        self.feed = categories
        self.identifiers = self.feed.flatMap { category in category.recipes.map(\.id) }
        self.identifiersSubject.send(self.identifiers)
    }

    public func observeFeed() -> AnyPublisher<[RecipeCategory], Never> {
        return identifiersSubject
            .compactMap { $0 }
            .mapAsync { [recipesStorage] ids in
                await recipesStorage.observeRecipes(by: ids)
            }
            .switchToLatest()
            .mapAsync { [weak self] recipes in
                await self?.updateFeed(accordingTo: recipes) ?? []
            }
            .eraseToAnyPublisher()
    }

    // MARK: - Private methods

    private func updateFeed(accordingTo recipes: [Recipe]) -> [RecipeCategory] {
        let recipesDictionary = Dictionary(grouping: recipes, by: \.id)
            .compactMapValues(\.first)
        return feed.map { category in
            let updatedRecipes = category.recipes.map { recipesDictionary[$0.id] ?? $0 }
            return RecipeCategory(recipes: updatedRecipes, category: category.type)
        }
    }
}
