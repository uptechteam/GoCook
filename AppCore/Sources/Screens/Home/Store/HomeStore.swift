//
//  HomeStore.swift
//  
//
//  Created by Oleksii Andriushchenko on 13.06.2022.
//

import DomainModels
import Foundation
import Helpers

public extension HomeViewController {

    typealias Store = ReduxStore<State, Action>

    struct State: Equatable {
        var recipeCategories: [RecipeCategory]
        var searchQuery: String
        var route: AnyIdentifiable<Route>?
    }

    enum Action {
        case didTapFilters
        case didTapItem(IndexPath)
        case didTapLike(IndexPath)
        case didTapViewAll(IndexPath)
        case didChangeSearchQuery(String)
    }

    enum Route {
        case filters
        case itemDetails(Recipe)
        case recipeCategory(RecipeCategory)
    }

    struct Dependencies {
        public init() {

        }
    }

    static func makeStore(dependencies: Dependencies) -> Store {
        return Store(
            initialState: makeInitialState(dependencies: dependencies),
            reducer: reduce,
            middlewares: []
        )
    }

    private static func makeInitialState(dependencies: Dependencies) -> State {
        return State(
            recipeCategories: [
                RecipeCategory(category: "Trending", recipes: [createRecipe(), createRecipe(), createRecipe(), createRecipe(), createRecipe()]),
                RecipeCategory(category: "Breakfast", recipes: [createRecipe(), createRecipe(), createRecipe(), createRecipe(), createRecipe()]),
                RecipeCategory(category: "Lunch", recipes: [createRecipe(), createRecipe(), createRecipe(), createRecipe(), createRecipe()]),
                RecipeCategory(category: "Dinner", recipes: [createRecipe(), createRecipe(), createRecipe(), createRecipe(), createRecipe()]),
                RecipeCategory(category: "Drinks", recipes: [createRecipe(), createRecipe(), createRecipe(), createRecipe(), createRecipe()])
            ],
            searchQuery: "",
            route: nil
        )
    }
}

extension HomeViewController {
    static func reduce(state: State, action: Action) -> State {

        var newState = state

        switch action {
        case .didTapFilters:
            newState.route = .init(value: .filters)

        case .didTapItem(let indexPath):
            guard let recipe = newState.recipeCategories[safe: indexPath.section]?.recipes[safe: indexPath.item] else {
                print("Error")
                break
            }

            newState.route = .init(value: .itemDetails(recipe))

        case .didTapLike(let indexPath):
            guard let recipe = newState.recipeCategories[safe: indexPath.section]?.recipes[safe: indexPath.item] else {
                print("Error")
                break
            }

            print("Press like for \(recipe)")

        case .didTapViewAll(let indexPath):
            guard let category = newState.recipeCategories[safe: indexPath.section] else {
                print("Error")
                break
            }

            newState.route = .init(value: .recipeCategory(category))

        case .didChangeSearchQuery(let query):
            newState.searchQuery = query
        }

        return newState
    }
}

private let url = URL(string: "https://i2.wp.com/www.downshiftology.com/wp-content/uploads/2018/12/Shakshuka-19.jpg")!
private func createRecipe() -> Recipe {
    Recipe(id: .init(rawValue: UUID().uuidString), name: "Green Hummus with sizzled dolmades", recipeImageSource: .remote(url: url), rating: 4.8)
}
