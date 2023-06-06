//
//  ProfilePresenter.swift
//  
//
//  Created by Oleksii Andriushchenko on 06.06.2023.
//

import BusinessLogic
import Combine
import DomainModels
import Foundation
import Helpers
import UIKit

@MainActor
public final class ProfilePresenter {

    // MARK: - Properties

    public let profileFacade: ProfileFacading
    public let profileRecipesFacade: ProfileRecipesFacading
    public let recipesFacade: RecipesFacading
    @Published
    private(set) var state: State

    // MARK: - Lifecycle

    public init(profileFacade: ProfileFacading, profileRecipesFacade: ProfileRecipesFacading, recipesFacade: RecipesFacading) {
        self.profileFacade = profileFacade
        self.profileRecipesFacade = profileRecipesFacade
        self.recipesFacade = recipesFacade
        self.state = State.makeInitialState()
        Task {
            await observeRecipes()
        }
        Task {
            await observeProfile()
        }
    }

    // MARK: - Public methods

    func addNewRecipeTapped() {
        state.route = .init(value: .createRecipe)
    }

    func contentActionTapped() async {
        if state.isEmptyContent {
            state.route = .init(value: .createRecipe)
        } else if state.isErrorPresent {
            await getRecipes()
        }
    }

    func editTapped() {
        state.route = .init(value: .edit)
    }

    func favoriteTapped(indexPath: IndexPath) async {
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
        guard let recipe = state.recipes[safe: indexPath.item] else {
            return
        }

        state.route = .init(value: .recipe(recipe))
    }

    func scrolledToEnd() async {
        do {
            try await profileRecipesFacade.getNextPage()
        } catch {
            state.recipes.handle(error: error)
        }
    }

    func scrolledToRefresh() async {
        await getRecipes()
    }

    func settingsTapped() {
        state.route = .init(value: .settings)
    }

    func signInTapped() {
        state.route = .init(value: .signIn)
    }

    func viewDidLoad() async {
        await getRecipes()
    }

    // MARK: - Private methods

    private func getRecipes() async {
        state.recipes.toggleIsLoading(on: true)
        do {
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            try await profileRecipesFacade.getFirstPage()
            state.recipes.toggleIsLoading(on: false)
        } catch {
            state.recipes.handle(error: error)
        }
    }

    private func observeRecipes() async {
        for await recipes in await profileRecipesFacade.observeFeed().values {
            state.recipes.handle(model: recipes)
        }
    }

    private func observeProfile() async {
        for await profile in profileFacade.profile.values {
            state.profile = profile
        }
    }
}
