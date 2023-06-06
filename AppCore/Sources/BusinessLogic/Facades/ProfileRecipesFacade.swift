//
//  ProfileRecipesFacade.swift
//  
//
//  Created by Oleksii Andriushchenko on 10.03.2023.
//

import Combine
import DomainModels
import Helpers

public protocol ProfileRecipesFacading: Sendable {
    func getFirstPage() async throws
    func getNextPage() async throws
    func observeFeed() async -> AnyPublisher<[Recipe], Never>
}

public actor ProfileRecipesFacade: ProfileRecipesFacading {

    // MARK: - Properties

    private let profileFacade: ProfileFacading
    private let recipesClient: RecipesClienting
    private let recipesStorage: RecipesStoraging
    private var cancellables: [AnyCancellable]
    private let paginator: RecipesPaginator
    private var profileID: User.ID?

    // MARK: - Lifecycle

    public init(profileFacade: ProfileFacading, recipesClient: RecipesClienting, recipesStorage: RecipesStoraging) {
        self.profileFacade = profileFacade
        self.recipesClient = recipesClient
        self.recipesStorage = recipesStorage
        self.cancellables = []
        self.paginator = RecipesPaginator()
        Task {
            await observeProfile()
        }
    }

    // MARK: - Public methods

    public func getFirstPage() async throws {
        guard let profileID else {
            return
        }

        let recipes = try await recipesClient.fetchRecipes(authorID: profileID, page: 0)
        await recipesStorage.store(recipes: recipes)
        await paginator.handle(recipes: recipes)
    }

    public func getNextPage() async throws {
        let page = await paginator.page
        guard let profileID, page > 0 else {
            return
        }

        let recipes = try await recipesClient.fetchRecipes(authorID: profileID, page: page)
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

    // MARK: - Private methods

    private func observeProfile() async {
        for await profile in profileFacade.profile.values {
            if let profile {
                self.profileID = profile.id
            } else {
                self.profileID = nil
                await paginator.reset()
            }
        }
    }
}
