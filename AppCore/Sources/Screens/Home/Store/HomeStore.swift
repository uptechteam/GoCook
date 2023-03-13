//
//  HomeStore.swift
//  
//
//  Created by Oleksii Andriushchenko on 13.06.2022.
//

import BusinessLogic
import DomainModels
import Foundation
import Helpers

public extension HomeViewController {

    typealias Store = ReduxStore<State, Action>

    struct State: Equatable {
        var isGettingRecipes: Bool
        var recipeCategories: DomainModelState<[RecipeCategory]>
        var pendingRecipe: Recipe?
        var searchedRecipes: [Recipe]
        var searchQuery: String
        var selectedCategories: Set<CategoryType>
        var route: AnyIdentifiable<Route>?

        var trendingCategory: RecipeCategory {
            recipeCategories.items.first(where: \.isTrendingCategory) ?? .init(category: .trending, recipes: [])
        }

        var otherCategories: [RecipeCategory] {
            recipeCategories.items.filter { !$0.isTrendingCategory }
        }
    }

    enum Action {
        case categoryTapped(IndexPath)
        case changeIsFavorite(Result<Void, Error>)
        case favoriteTapped(IndexPath, isTrending: Bool)
        case filtersTapped
        case getFeed(Result<[RecipeCategory], Error>)
        case getRecipes(Result<Void, Error>)
        case recipeTapped(IndexPath, isTrending: Bool)
        case scrolledSearchToEnd
        case searchFavoriteTapped(IndexPath)
        case searchQueryChanged(String)
        case searchRecipeTapped(IndexPath)
        case updateRecipes([Recipe])
        case viewAllTapped(Int, isTrending: Bool)
        case viewDidLoad
    }

    enum Route {
        case filters
        case itemDetails(Recipe)
        case recipeCategory(RecipeCategory)
    }

    struct Dependencies {

        // MARK: - Properties

        let recipesClient: RecipesClienting
        let recipesFacade: RecipesFacading
        let searchRecipesFacade: SearchRecipesFacading

        // MARK: - Public methods

        public init(
            recipesClient: RecipesClienting,
            recipesFacade: RecipesFacading,
            searchRecipesFacade: SearchRecipesFacading
        ) {
            self.recipesClient = recipesClient
            self.recipesFacade = recipesFacade
            self.searchRecipesFacade = searchRecipesFacade
        }
    }

    static func makeStore(dependencies: Dependencies) -> Store {
        let changeIsFavoriteMiddleware = makeChangeIsFavoriteMiddleware(dependencies: dependencies)
        let getFeedMiddleware = makeGetFeedMiddleware(dependencies: dependencies)
        let getFirstPageRecipesMiddleware = makeGetFirstPageRecipesMiddleware(dependencies: dependencies)
        let getNextPageRecipesMiddleware = makeGetNextPageRecipesMiddleware(dependencies: dependencies)
        return Store(
            initialState: makeInitialState(dependencies: dependencies),
            reducer: reduce,
            middlewares: [
                changeIsFavoriteMiddleware,
                getFeedMiddleware,
                getFirstPageRecipesMiddleware,
                getNextPageRecipesMiddleware
            ]
        )
    }

    private static func makeInitialState(dependencies: Dependencies) -> State {
        return State(
            isGettingRecipes: false,
            recipeCategories: .init(),
            searchedRecipes: [],
            searchQuery: "",
            selectedCategories: Set(),
            route: nil
        )
    }
}

extension HomeViewController {
    // swiftlint:disable:next cyclomatic_complexity function_body_length
    static func reduce(state: State, action: Action) -> State {

        var newState = state

        switch action {
        case let .categoryTapped(indexPath):
            if indexPath.item == 0 {
                newState.selectedCategories.removeAll()
            } else if let selectedCategory = CategoryType.priorityOrder[safe: indexPath.item - 1] {
                if newState.selectedCategories.contains(selectedCategory) {
                    newState.selectedCategories.remove(selectedCategory)
                } else {
                    newState.selectedCategories.insert(selectedCategory)
                }
            }

        case .changeIsFavorite:
            newState.pendingRecipe = nil

        case let .favoriteTapped(indexPath, isTrending):
            let category = isTrending ? newState.trendingCategory : newState.otherCategories[safe: indexPath.section]
            guard let recipe = category?.recipes[safe: indexPath.item], newState.pendingRecipe == nil else {
                break
            }

            newState.pendingRecipe = recipe

        case .filtersTapped:
            newState.route = .init(value: .filters)

        case .getFeed(let result):
            newState.recipeCategories.handle(result: result)

        case .getRecipes:
            newState.isGettingRecipes = false

        case let .recipeTapped(indexPath, isTrending):
            let category = isTrending ? newState.trendingCategory : newState.otherCategories[safe: indexPath.section]
            guard let recipe = category?.recipes[safe: indexPath.item] else {
                break
            }

            newState.route = .init(value: .itemDetails(recipe))

        case .scrolledSearchToEnd:
            break

        case .searchFavoriteTapped(let indexPath):
            guard let recipe = newState.searchedRecipes[safe: indexPath.item], newState.pendingRecipe == nil else {
                break
            }

            newState.pendingRecipe = recipe

        case .searchQueryChanged(let query):
            newState.searchQuery = query
            if !query.isEmpty {
                newState.isGettingRecipes = true
            }

        case .searchRecipeTapped(let indexPath):
            guard let recipe = newState.searchedRecipes[safe: indexPath.item] else {
                break
            }

            newState.route = .init(value: .itemDetails(recipe))

        case .updateRecipes(let recipes):
            newState.searchedRecipes = recipes

        case let .viewAllTapped(index, isTrending):
            let category = isTrending ? newState.trendingCategory : newState.otherCategories[safe: index]
            guard let category else {
                break
            }

            newState.route = .init(value: .recipeCategory(category))

        case .viewDidLoad:
            newState.recipeCategories.toggleIsLoading(on: true)
        }

        return newState
    }
}
