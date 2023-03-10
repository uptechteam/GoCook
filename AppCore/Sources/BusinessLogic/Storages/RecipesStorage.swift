//
//  RecipesStorage.swift
//  
//
//  Created by Oleksii Andriushchenko on 10.03.2023.
//

import Combine
import DomainModels

public protocol RecipesStoraging: Sendable {
    func observeRecipes(by ids: [Recipe.ID]) async -> AnyPublisher<[Recipe], Never>
    func store(recipes: [Recipe]) async
}

public extension RecipesStoraging {
    func store(recipe: Recipe) async {
        await store(recipes: [recipe])
    }
}

public actor RecipesStorage: RecipesStoraging {

    // MARK: - Properties

    private var recipes: [Recipe.ID: Recipe]
    private let recipesSubject: CurrentValueSubject<[Recipe.ID: Recipe], Never>

    // MARK: - Lifecycle

    public init() {
        self.recipes = [:]
        self.recipesSubject = CurrentValueSubject([:])
    }

    // MARK: - Public methods

    public func observeRecipes(by ids: [Recipe.ID]) -> AnyPublisher<[Recipe], Never> {
        return recipesSubject
            .map { recipes in ids.compactMap { recipes[$0] } }
            .eraseToAnyPublisher()
    }

    public func store(recipes: [Recipe]) {
        for recipe in recipes {
            self.recipes[recipe.id] = recipe
        }

        self.recipesSubject.send(self.recipes)
    }
}
