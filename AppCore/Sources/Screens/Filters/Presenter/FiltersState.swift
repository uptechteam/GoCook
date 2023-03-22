//
//  FiltersState.swift
//  
//
//  Created by Oleksii Andriushchenko on 21.03.2023.
//

import DomainModels
import Helpers

extension FiltersPresenter {

    // MARK: - State

    struct State: Equatable {

        // MARK: - Properties

        var allCategories: [CategoryType]
        var allTimeFilters: [RecipeTimeFilter]
        var appliedFilters: RecipeFilters
        var selectedCategories: Set<CategoryType>
        var selectedTimeFilters: Set<RecipeTimeFilter>
        var route: AnyIdentifiable<Route>?

        // MARK: - Public methods

        func makeFilters() -> RecipeFilters {
            return .init(
                categories: allCategories.filter(selectedCategories.contains),
                timeFilters: allTimeFilters.filter(selectedTimeFilters.contains)
            )
        }

        mutating func adjustState(accordingTo filters: RecipeFilters) {
            appliedFilters = filters
            selectedCategories = Set(filters.categories)
            selectedTimeFilters = Set(filters.timeFilters)
        }

        static func makeInitialState() -> State {
            return State(
                allCategories: [.breakfast, .lunch, .dinner, .desserts, .drinks],
                allTimeFilters: [.fiveToFifteen, .fifteenToThirty, .thirtyToFortyFive, .moreThanFortyFive],
                appliedFilters: RecipeFilters(categories: [], timeFilters: []),
                selectedCategories: Set(),
                selectedTimeFilters: Set(),
                route: nil
            )
        }
    }

    // MARK: - Route

    enum Route {
        case didApplyFilters
    }
}
