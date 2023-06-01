//
//  AuthorProps.swift
//  
//
//  Created by Oleksii Andriushchenko on 31.05.2023.
//

import DomainModels
import Library

extension AuthorPresenter {
    static func makeProps(from state: State) -> AuthorView.Props {
        return .init(
            headerViewProps: makeHeaderViewProps(state: state),
            isCollectionViewVisible: !state.recipes.isEmpty,
            items: makeItems(state: state),
            recipesStateViewProps: makeRecipesStateViewProps(state: state)
        )
    }

    private static func makeHeaderViewProps(state: State) -> AuthorHeaderView.Props {
        return .init(
            avatarImageSource: state.author.avatar,
            name: state.author.username
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

    private static func makeRecipesStateViewProps(state: State) -> ContentStateView.Props {
        if state.recipes.isLoading {
            return .loading
        } else if state.recipes.isEmpty {
            return .message(title: .authorRecipesEmptyText, buttonTitle: nil)
        } else {
            return .hidden
        }
    }
}
