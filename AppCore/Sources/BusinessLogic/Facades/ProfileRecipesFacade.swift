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

        let recipes = try await recipesClient.fetchRecipes(authorID: profileID)
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
}
