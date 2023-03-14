//
//  FavoritesProps.swift
//  
//
//  Created by Oleksii Andriushchenko on 15.06.2022.
//

import DomainModels
import Library

extension FavoritesViewController {
    static func makeProps(from state: FavoritesPresenter.State) -> FavoritesView.Props {
        return .init(
            recipesViewProps: makeRecipesViewProps(state: state),
            contentStateViewProps: makeContentStateViewProps(state: state)
        )
    }

    private static func makeRecipesViewProps(state: FavoritesPresenter.State) -> FavoriteRecipesView.Props {
        return .init(
            isVisible: !state.recipes.isEmpty,
            items: makeItems(state: state),
            isSpinnerVisible: state.recipes.isLoading,
            isNoResultsLabelVisible: state.recipes.isPresent && state.recipes.isEmpty
        )
    }

    private static func makeItems(state: FavoritesPresenter.State) -> [SmallRecipeCell.Props] {
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

    private static func makeContentStateViewProps(state: FavoritesPresenter.State) -> ContentStateView.Props {
        if state.recipes.isLoading && state.recipes.isEmpty {
            return .loading
        } else if state.recipes.isEmpty && state.recipes.error == nil {
            return .message(title: .favoritesEmptyTitle, buttonTitle: .favoritesEmptyButton)
        } else {
            return .hidden
        }
    }
}
