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
        var pendingRecipe: Recipe?
        var query: String
        var recipes: DomainModelState<[Recipe]>
        var route: AnyIdentifiable<Route>?
    }

    enum Route {
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
        self.state = State(query: "", recipes: DomainModelState(), route: nil)
        Task {
            await observeRecipes()
        }
    }

    // MARK: - Public methods

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
    }

    func viewDidAppear() async {
        do {
            try await favoriteRecipesFacade.getFavoriteRecipes()
            state.recipes.adjustState(accordingTo: .success(()))
        } catch {
            print("Error: \(error.localizedDescription)")
            state.recipes.adjustState(accordingTo: Result<Void, Error>.failure(error))
        }
    }

    // MARK: - Private methods

    private func observeRecipes() async {
        for await recipes in await favoriteRecipesFacade.observeFeed().values {
            state.recipes.update(with: recipes)
        }
    }
}
