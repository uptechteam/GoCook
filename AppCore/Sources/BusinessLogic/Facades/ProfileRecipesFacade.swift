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
    private var identifiers: [Recipe.ID]
    private let identifiersSubject: CurrentValueSubject<[Recipe.ID], Never>
    private var page: Int = 0
    private var profileID: User.ID?

    // MARK: - Lifecycle

    public init(profileFacade: ProfileFacading, recipesClient: RecipesClienting, recipesStorage: RecipesStoraging) {
        self.profileFacade = profileFacade
        self.recipesClient = recipesClient
        self.recipesStorage = recipesStorage
        self.cancellables = []
        self.identifiers = []
        self.identifiersSubject = CurrentValueSubject([])
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
        self.page = 1
        await self.recipesStorage.store(recipes: recipes)
        self.updateIdentifiers(ids: recipes.map(\.id))
    }

    public func getNextPage() async throws {
        guard let profileID, page > 0 else {
            return
        }

        let recipes = try await recipesClient.fetchRecipes(authorID: profileID, page: page)
        if recipes.count != AppConstants.Pagination.pageSize {
            self.page = 0
        } else {
            self.page += 1
        }

        await self.recipesStorage.store(recipes: recipes)
        self.updateIdentifiers(ids: self.identifiers + recipes.map(\.id))
    }

    public func observeFeed() -> AnyPublisher<[Recipe], Never> {
        return identifiersSubject.eraseToAnyPublisher()
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
                identifiers = []
                identifiersSubject.send([])
            }
        }
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
