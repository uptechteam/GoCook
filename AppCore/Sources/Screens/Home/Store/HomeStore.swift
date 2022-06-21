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
        var recipeCategories: DomainModelState<[RecipeCategory]>
        var searchQuery: String
        var route: AnyIdentifiable<Route>?
    }

    enum Action {
        case didTapFilters
        case didTapItem(IndexPath)
        case didTapLike(IndexPath)
        case didTapViewAll(IndexPath)
        case didChangeSearchQuery(String)
        case getFeed(DomainModelAction<[RecipeCategory]>)
    }

    enum Route {
        case filters
        case itemDetails(Recipe)
        case recipeCategory(RecipeCategory)
    }

    struct Dependencies {
        let recipesClient: RecipesClienting

        public init(recipesClient: RecipesClienting) {
            self.recipesClient = recipesClient
        }
    }

    static func makeStore(dependencies: Dependencies) -> Store {
        let getFeedMiddleware = makeGetFeedMiddleware(dependencies: dependencies)
        return Store(
            initialState: makeInitialState(dependencies: dependencies),
            reducer: reduce,
            middlewares: [getFeedMiddleware]
        )
    }

    private static func makeInitialState(dependencies: Dependencies) -> State {
        return State(
            recipeCategories: .init(),
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

        case .getFeed(let modelAction):
            newState.recipeCategories.handle(action: modelAction)
        }

        return newState
    }
}
