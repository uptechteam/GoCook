//
//  AuthorPresenter.swift
//  
//
//  Created by Oleksii Andriushchenko on 31.05.2023.
//

import BusinessLogic
import Combine
import Foundation

@MainActor
public final class AuthorPresenter {

    // MARK: - Properties

    private let recipesFacade: RecipesFacading
    private let userRecipesFacade: UserRecipesFacading
    @Published
    private(set) var state: State

    // MARK: - Lifecycle

    public init(recipesFacade: RecipesFacading, userRecipesFacade: UserRecipesFacading, envelope: AuthorEnvelope) {
        self.recipesFacade = recipesFacade
        self.userRecipesFacade = userRecipesFacade
        self.state = State.makeInitialState(envelope: envelope)
        Task {
            await observeRecipes()
        }
    }

    // MARK: - Public methods

    func backTapped() {
        state.route = .init(value: .didTapBack)
    }

    func contentActionTapped() async {
        if state.isErrorPresent {
            await getFirstPage()
        }
    }

    func isFavoriteTapped(indexPath: IndexPath) async {
        guard let recipe = state.recipes.items[safe: indexPath.item] else {
            return
        }

        if recipe.isFavorite {
            try? await recipesFacade.removeFromFavorites(recipeID: recipe.id)
        } else {
            try? await recipesFacade.addToFavorites(recipeID: recipe.id)
        }
    }

    func recipeTapped(indexPath: IndexPath) {
        guard let recipe = state.recipes.items[safe: indexPath.item] else {
            return
        }

        state.route = .init(value: .didTapRecipe(recipe))
    }

    func scrolledToEnd() async {
        do {
            try await userRecipesFacade.getNextPage()
        } catch {
            state.alert = .init(value: .error(message: error.localizedDescription))
        }
    }

    func scrolledToRefresh() async {
        await getFirstPage()
    }

    func viewDidLoad() async {
        await getFirstPage()
    }

    // MARK: - Private methods

    private func getFirstPage() async {
        do {
            state.recipes.toggleIsLoading(on: true)
            try await userRecipesFacade.getFirstPage()
            state.recipes.toggleIsLoading(on: false)
        } catch {
            state.recipes.handle(error: error)
        }
    }

    private func observeRecipes() async {
        for await recipes in await userRecipesFacade.observeFeed().values {
            state.recipes.handle(model: recipes)
        }
    }
}
