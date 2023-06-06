//
//  RecipesPaginator.swift
//  
//
//  Created by Oleksii Andriushchenko on 13.03.2023.
//

import Combine
import DomainModels
import Helpers

public actor RecipesPaginator {

    // MARK: - Properties

    private var identifiers: [Recipe.ID]
    let identifiersSubject: CurrentValueSubject<[Recipe.ID]?, Never>
    private(set) var page: Int

    // MARK: - Lifecycle

    public init() {
        self.identifiers = []
        self.identifiersSubject = CurrentValueSubject(nil)
        self.page = 0
    }

    // MARK: - Public methods

    public func handle(recipes: [Recipe]) {
        if recipes.count != AppConstants.Pagination.pageSize {
            self.page = 0
        } else {
            self.page += 1
        }

        updateIdentifiers(ids: self.identifiers + recipes.map(\.id))
    }

    public func reset() {
        guard !identifiers.isEmpty else {
            return
        }

        self.identifiers = []
        self.identifiersSubject.send(self.identifiers)
    }

    // MARK: - Private methods

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
