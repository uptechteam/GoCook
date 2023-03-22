//
//  FavoritesState.swift
//  
//
//  Created by Oleksii Andriushchenko on 21.03.2023.
//

import DomainModels
import Foundation
import Helpers

extension FavoritesPresenter {

    // MARK: - State

    struct State: Equatable {

        // MARK: - Properties

        var filters: RecipeFilters
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

        static func makeInitialState() -> State {
            return State(
                filters: RecipeFilters(categories: [], timeFilters: []),
                pendingRecipe: nil,
                query: "",
                recipes: DomainModelState(),
                route: nil
            )
        }
    }

    // MARK: - Route

    enum Route {
        case didTapExplore
        case didTapFilters
        case didTapRecipe(Recipe)
    }
}
