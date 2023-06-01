//
//  FavoritesProps.swift
//  
//
//  Created by Oleksii Andriushchenko on 15.06.2022.
//

import DomainModels
import Library

extension FavoritesPresenter {
    static func makeProps(from state: State) -> FavoritesView.Props {
        return .init(
            filtersIcon: .asset(state.filters.isEmpty ? .filters : .filterActive),
            filterDescriptionViewProps: makeFilterDescriptionViewProps(state: state),
            recipesViewProps: makeRecipesViewProps(state: state),
            contentStateViewProps: makeContentStateViewProps(state: state)
        )
    }

    private static func makeFilterDescriptionViewProps(state: State) -> FiltersDescriptionView.Props {
        return .init(
            isVisible: !state.filters.isEmpty,
            description: makeDescription(state: state)
        )
    }

    private static func makeDescription(state: State) -> String {
        var description: String = .favoritesFilterDescription
        if !state.filters.categories.isEmpty {
            let categoriesDescription = state.filters.categories
                .map(\.name)
                .joined(separator: .favoritesCategoriesJoinText)
            description.append(.favoritesFilterDescriptionCategories(categoriesDescription))
        }

        if !state.filters.timeFilters.isEmpty {
            let timeDescription = state.filters.timeFilters
                .map(makeTimeFilterDescription)
                .joined(separator: .favoritesTimeFiltersJoinText)
            description.append(.favoritesFilterDescriptionCookingTime(timeDescription))
        }

        return description
    }

    private static func makeTimeFilterDescription(timeFilter: RecipeTimeFilter) -> String {
        switch timeFilter {
        case .fifteenToThirty:
            return .favoritesCookingTimeFifteenToThirty

        case .fiveToFifteen:
            return .favoritesCookingTimeFiveToFifteen

        case .moreThanFortyFive:
            return .favoritesCookingTimeMoreThanFortyFive

        case .thirtyToFortyFive:
            return .favoritesCookingTimeThirtyToFortyFive
        }
    }

    private static func makeRecipesViewProps(state: State) -> FavoriteRecipesView.Props {
        return .init(
            isVisible: !state.recipes.isEmpty,
            items: makeItems(state: state)
        )
    }

    private static func makeItems(state: State) -> [SmallRecipeCell.Props] {
        return state.recipes.items.map { recipe in
            return SmallRecipeCell.Props(
                id: recipe.id.rawValue,
                recipeImageSource: recipe.recipeImageSource,
                isFavorite: recipe.isFavorite,
                name: recipe.name,
                ratingViewProps: makeRatingViewProps(recipe: recipe)
            )
        }
    }

    private static func makeRatingViewProps(recipe: Recipe) -> RatingView.Props {
        return .init(
            ratingText: "\(recipe.rating)",
            isReviewsLabelVisible: false,
            reviewsText: ""
        )
    }

    private static func makeContentStateViewProps(state: State) -> ContentStateView.Props {
        guard state.recipes.isEmpty else {
            return state.recipes.isEmpty ? .message(title: .favoritesNoResultsTitle, buttonTitle: nil) : .hidden
        }

        if state.recipes.isLoading {
            return .loading
        } else if state.areFavoriteRecipesEmpty {
            return .message(title: .favoritesEmptyTitle, buttonTitle: .favoritesEmptyButton)
        } else if state.areFilteredRecipesEmpty {
            return .message(title: .favoritesFilteredEmptyTitle, buttonTitle: .favoritesFilteredEmptyButton)
        } else if state.isError {
            return .message(title: .favoritesErrorTitle, buttonTitle: .favoritesErrorButton)
        } else {
            return .hidden
        }
    }
}
