//
//  FavoritesPresenter.swift
//  
//
//  Created by Oleksii Andriushchenko on 13.03.2023.
//

import BusinessLogic
import Combine
import DomainModels
import Foundation
import Helpers

@MainActor
public final class FavoritesPresenter {

    struct State: Equatable {

        // MARK: - Properties

        var filteredRecipes: [Recipe]
        var pendingRecipe: Recipe?
        var query: String
        var recipes: DomainModelState<[Recipe]>
        var route: AnyIdentifiable<Route>?

        var areFavoriteRecipesEmpty: Bool {
            recipes.isPresent && recipes.isEmpty && recipes.error == nil
        }

        var isError: Bool {
            recipes.isEmpty && recipes.error != nil
        }

        // MARK: - Public methods

        mutating func updateFilteredRecipes() {
            guard !query.isEmpty else {
                self.filteredRecipes = recipes.items
                return
            }

            let lowercasedQuery = query.lowercased()
            self.filteredRecipes = recipes.items.filter { $0.name.lowercased().contains(lowercasedQuery) }
        }
    }

    enum Route {
        case didTapExplore
        case didTapFilters
        case didTapRecipe(Recipe)
    }

    // MARK: - Properties

    @Dependency
    private var favoriteRecipesFacade: FavoriteRecipesFacading
    @Dependency
    private var recipesFacade: RecipesFacading
    @Published
    private(set) var state: State

    // MARK: - Lifecycle

    public init() {
        self.state = State(filteredRecipes: [], query: "", recipes: DomainModelState(), route: nil)
        Task {
            await observeRecipes()
        }
    }

    // MARK: - Public methods

    func contentStateActionTapped() async {
        if state.areFavoriteRecipesEmpty {
            state.route = .init(value: .didTapExplore)
        } else if state.isError {
            await getFavoriteRecipes()
        }
    }

    func favoriteTapped(indexPath: IndexPath) async {
        guard let recipe = state.recipes[safe: indexPath.item], state.pendingRecipe == nil else {
            return
        }

        state.pendingRecipe = recipe
        do {
            if recipe.isFavorite {
                try await recipesFacade.removeFromFavorites(recipeID: recipe.id)
            } else {
                try await recipesFacade.addToFavorites(recipeID: recipe.id)
            }

            state.pendingRecipe = nil
        } catch {
            state.pendingRecipe = nil
            print("Error: \(error.localizedDescription)")
        }
    }

    func filtersTapped() {
        state.route = .init(value: .didTapFilters)
    }

    func recipeTapped(indexPath: IndexPath) {
        guard let recipe = state.recipes[safe: indexPath.item] else {
            return
        }

        state.route = .init(value: .didTapRecipe(recipe))
    }

    func searchQueryChanged(_ query: String) {
        state.query = query
        state.updateFilteredRecipes()
    }

    func viewDidAppear() async {
        await getFavoriteRecipes()
    }

    // MARK: - Private methods

    private func getFavoriteRecipes() async {
        state.recipes.toggleIsLoading(on: true)
        do {
            try await favoriteRecipesFacade.getFavoriteRecipes()
            state.recipes.adjustState(accordingTo: .success(()))
        } catch {
            state.recipes.adjustState(accordingTo: Result<Void, Error>.failure(error))
        }
    }

    private func observeRecipes() async {
        for await recipes in await favoriteRecipesFacade.observeFeed().values {
            state.recipes.update(with: recipes)
            state.updateFilteredRecipes()
        }
    }
}
