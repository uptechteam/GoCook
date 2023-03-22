//
//  HomePresenter.swift
//  
//
//  Created by Oleksii Andriushchenko on 22.03.2023.
//

import BusinessLogic
import Combine
import DomainModels
import Foundation

@MainActor
public final class HomePresenter {

    // MARK: - Properties

    let filtersFacade: FiltersFacading
    let homeFeedFacade: HomeFeedFacading
    let recipesFacade: RecipesFacading
    let searchRecipesFacade: SearchRecipesFacading
    @Published
    private(set) var state: State
    private var getRecipesPageTask: Task<(), Never>?

    // MARK: - Lifecycle

    init(
        filtersFacade: FiltersFacading,
        homeFeedFacade: HomeFeedFacading,
        recipesFacade: RecipesFacading,
        searchRecipesFacade: SearchRecipesFacading
    ) {
        self.filtersFacade = filtersFacade
        self.homeFeedFacade = homeFeedFacade
        self.recipesFacade = recipesFacade
        self.searchRecipesFacade = searchRecipesFacade
        self.state = State.makeInitialState()
        Task {
            await observeFilters()
        }
        Task {
            await observeFeed()
        }
        Task {
            await observeRecipes()
        }
    }

    // MARK: - Public methods

    func categoryTapped(indexPath: IndexPath) {
        if indexPath.item == 0 {
            state.selectedCategories.removeAll()
        } else if let selectedCategory = CategoryType.priorityOrder[safe: indexPath.item - 1] {
            if state.selectedCategories.contains(selectedCategory) {
                state.selectedCategories.remove(selectedCategory)
            } else {
                state.selectedCategories.insert(selectedCategory)
            }
        }
    }

    func favoriteTapped(indexPath: IndexPath, isTrending: Bool) async {
        let category = isTrending ? state.trendingCategory : state.otherCategories[safe: indexPath.section]
        guard let recipe = category?.recipes[safe: indexPath.item], state.pendingRecipe == nil else {
            return
        }

        state.pendingRecipe = recipe
        await changeIsFavorite(recipe: recipe)
    }

    func filtersTapped() {
        state.route = .init(value: .didTapFilters)
    }

    func recipeTapped(indexPath: IndexPath, isTrending: Bool) {
        let category = isTrending ? state.trendingCategory : state.otherCategories[safe: indexPath.section]
        guard let recipe = category?.recipes[safe: indexPath.item] else {
            return
        }

        state.route = .init(value: .didTapRecipe(recipe))
    }

    func scrolledSearchToEnd() {
        guard !state.searchQuery.isEmpty else {
            return
        }

        getRecipesPageTask = Task {
            try? await searchRecipesFacade.getNextPage(query: state.searchQuery, filter: state.filters)
        }
    }

    func searchFavoriteTapped(indexPath: IndexPath) async {
        guard let recipe = state.searchedRecipes[safe: indexPath.item], state.pendingRecipe == nil else {
            return
        }

        state.pendingRecipe = recipe
        await changeIsFavorite(recipe: recipe)
    }

    func searchQueryChanged(query: String) {
        state.searchQuery = query
        getFirstPage()
    }

    func searchRecipeTapped(indexPath: IndexPath) {
        guard let recipe = state.searchedRecipes[safe: indexPath.item] else {
            return
        }

        state.route = .init(value: .didTapRecipe(recipe))
    }

    func viewAllTapped(index: Int, isTrending: Bool) {
        let category = isTrending ? state.trendingCategory : state.otherCategories[safe: index]
        // TODO: Update filter
    }

    func viewDidLoad() async {
        state.recipeCategories.toggleIsLoading(on: true)
        await getFeed()
    }

    // MARK: - Private methods

    private func changeIsFavorite(recipe: Recipe) async {
        do {
            if recipe.isFavorite {
                try await recipesFacade.removeFromFavorites(recipeID: recipe.id)
            } else {
                try await recipesFacade.addToFavorites(recipeID: recipe.id)
            }

            state.pendingRecipe = nil
        } catch {
            state.pendingRecipe = nil
        }
    }

    private func getFeed() async {
        do {
            try await homeFeedFacade.getFeed()
            state.recipeCategories.adjustState(accordingTo: .success(()))
        } catch {
            state.recipeCategories.adjustState(accordingTo: Result<Void, Error>.failure(error))
        }
    }

    private func getFirstPage() {
        getRecipesPageTask?.cancel()
        guard state.isSearchActive else {
            return
        }

        state.isGettingRecipes = true
        getRecipesPageTask = Task {
            try? await searchRecipesFacade.getFirstPage(query: state.searchQuery, filter: state.filters)
            guard !Task.isCancelled else {
                return
            }

            state.isGettingRecipes = false
        }
    }

    private func observeFeed() async {
        for await feed in await homeFeedFacade.observeFeed().values {
            state.recipeCategories.update(with: feed)
        }
    }

    private func observeFilters() async {
        for await filters in await filtersFacade.observeFilters().values {
            state.filters = filters
            getFirstPage()
        }
    }

    private func observeRecipes() async {
        for await recipes in await searchRecipesFacade.observeFeed().values {
            state.searchedRecipes = recipes
        }
    }
}
