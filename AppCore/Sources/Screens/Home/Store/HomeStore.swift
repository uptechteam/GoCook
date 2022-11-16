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
        var selectedCategories: Set<CategoryType>
        var route: AnyIdentifiable<Route>?
    }

    enum Action {
        case categoryTapped(IndexPath)
        case filtersTapped
        case getFeed(DomainModelAction<[RecipeCategory]>)
        case likeTapped(IndexPath)
        case recipeTapped(IndexPath)
        case searchQueryChanged(String)
        case viewAllTapped(Int)
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
        case .categoryTapped(let indexPath):
            if indexPath.item == 0 {
                newState.selectedCategories.removeAll()
            } else if let selectedCategory = CategoryType.priorityOrder[safe: indexPath.item - 1] {
                if newState.selectedCategories.contains(selectedCategory) {
                    newState.selectedCategories.remove(selectedCategory)
                } else {
                    newState.selectedCategories.insert(selectedCategory)
                }
            }

        case .filtersTapped:
            newState.route = .init(value: .filters)

        case .getFeed(let modelAction):
            newState.recipeCategories.handle(action: modelAction)

        case .likeTapped(let indexPath):
            guard let recipe = newState.recipeCategories[safe: indexPath.section]?.recipes[safe: indexPath.item] else {
                print("Error")
                break
            }

            print("Press like for \(recipe)")

        case .recipeTapped(let indexPath):
            guard let recipe = newState.recipeCategories[safe: indexPath.section]?.recipes[safe: indexPath.item] else {
                print("Error")
                break
            }

            newState.route = .init(value: .itemDetails(recipe))

        case .searchQueryChanged(let query):
            newState.searchQuery = query

        case .viewAllTapped(let index):
            guard let category = newState.recipeCategories[safe: index] else {
                print("Error")
                break
            }

            newState.route = .init(value: .recipeCategory(category))
        }

        return newState
    }
}
