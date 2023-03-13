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
    private var feedSubject: CurrentValueSubject<[RecipeCategory], Never>

    // MARK: - Lifecycle

    public init(recipesClient: RecipesClienting, recipesStorage: RecipesStoraging) {
        self.recipesClient = recipesClient
        self.recipesStorage = recipesStorage
        self.feed = []
        self.feedSubject = CurrentValueSubject([])
    }

    // MARK: - Public methods

    public func getFeed() async throws {
        let categories = try await recipesClient.fetchFeed()
        self.feed = categories
        self.feedSubject.send(self.feed)
    }

    public func observeFeed() -> AnyPublisher<[RecipeCategory], Never> {
        return feedSubject
            .eraseToAnyPublisher()
    }
}
