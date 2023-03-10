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
        case favoriteTapped(IndexPath, isTrending: Bool)
        case filtersTapped
        case getFeed(Result<[RecipeCategory], Error>)
        case getRecipes(Result<[Recipe], Error>)
        case recipeTapped(IndexPath, isTrending: Bool)
        case searchQueryChanged(String)
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

        // MARK: - Public methods

        public init(recipesClient: RecipesClienting) {
            self.recipesClient = recipesClient
        }
    }

    static func makeStore(dependencies: Dependencies) -> Store {
        let getFeedMiddleware = makeGetFeedMiddleware(dependencies: dependencies)
        let getRecipesMiddleware = makeGetRecipesMiddleware(dependencies: dependencies)
        return Store(
            initialState: makeInitialState(dependencies: dependencies),
            reducer: reduce,
            middlewares: [getFeedMiddleware, getRecipesMiddleware]
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
    // swiftlint:disable:next cyclomatic_complexity
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

        case let .favoriteTapped(indexPath, isTrending):
            let category = isTrending ? newState.trendingCategory : newState.otherCategories[safe: indexPath.section]
            guard let recipe = category?.recipes[safe: indexPath.item] else {
                break
            }

            print("Press favorite for \(recipe)")

        case .filtersTapped:
            newState.route = .init(value: .filters)

        case .getFeed(let result):
            newState.recipeCategories.handle(result: result)

        case .getRecipes(let result):
            newState.isGettingRecipes = false
            if case .success(let recipes) = result {
                newState.searchedRecipes = recipes
            }

        case let .recipeTapped(indexPath, isTrending):
            let category = isTrending ? newState.trendingCategory : newState.otherCategories[safe: indexPath.section]
            guard let recipe = category?.recipes[safe: indexPath.item] else {
                break
            }

            newState.route = .init(value: .itemDetails(recipe))

        case .searchQueryChanged(let query):
            newState.searchQuery = query
            if !query.isEmpty {
                newState.isGettingRecipes = true
            }

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
