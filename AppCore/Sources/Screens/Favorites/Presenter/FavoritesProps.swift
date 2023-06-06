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
            isVisible: !state.recipes.isEmpty || state.recipes.isLoading,
            collectionViewProps: makeCollectionViewProps(state: state)
        )
    }

    private static func makeCollectionViewProps(state: State) -> CollectionView<Int, FavoriteRecipesView.Item>.Props {
        let isShimmeringVisible = state.recipes.isEmpty && state.recipes.isLoading
        return .init(
            section: [0],
            items: [isShimmeringVisible ? makeShimmeringItems() : makeItems(state: state)],
            isRefreshing: state.recipes.isLoading
        )
    }

    private static func makeShimmeringItems() -> [FavoriteRecipesView.Item] {
        return [
            FavoriteRecipesView.Item.shimmering(0),
            FavoriteRecipesView.Item.shimmering(1),
            FavoriteRecipesView.Item.shimmering(2),
            FavoriteRecipesView.Item.shimmering(3),
            FavoriteRecipesView.Item.shimmering(4)
        ]
    }

    private static func makeItems(state: State) -> [FavoriteRecipesView.Item] {
        return state.recipes.items
            .map { recipe in
                return SmallRecipeCell.Props(
                    id: recipe.id.rawValue,
                    recipeImageSource: recipe.recipeImageSource,
                    isFavorite: recipe.isFavorite,
                    name: recipe.name,
                    ratingViewProps: RatingView.makeProps(recipe: recipe)
                )
            }
            .map(FavoriteRecipesView.Item.recipe)
    }

    private static func makeContentStateViewProps(state: State) -> ContentStateView.Props {
        guard state.recipes.isEmpty else {
            return state.recipes.isEmpty ? .message(title: .favoritesNoResultsTitle, buttonTitle: nil) : .hidden
        }

        if state.recipes.isLoading {
            return .hidden
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
