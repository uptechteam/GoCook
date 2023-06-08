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
            isCollectionViewVisible: !state.recipes.isEmpty || state.recipes.isLoading,
            collectionViewProps: makeCollectionViewProps(state: state),
            recipesStateViewProps: makeRecipesStateViewProps(state: state)
        )
    }

    private static func makeHeaderViewProps(state: State) -> AuthorHeaderView.Props {
        return .init(
            avatarImageSource: state.author.avatar ?? .asset(.avatarPlaceholder),
            name: state.author.username
        )
    }

    private static func makeCollectionViewProps(state: State) -> CollectionView<Int, AuthorView.Item>.Props {
        if state.recipes.isEmpty && state.recipes.isLoading {
            return .init(
                section: [0],
                items: [makeShimmeringItems()]
            )
        } else {
            return .init(
                section: [0],
                items: [makeItems(state: state)]
            )
        }
    }

    private static func makeItems(state: State) -> [AuthorView.Item] {
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
            .map(AuthorView.Item.recipe)
    }

    private static func makeShimmeringItems() -> [AuthorView.Item] {
        return [
            .shimmering(1),
            .shimmering(2),
            .shimmering(3)
        ]
    }

    private static func makeRecipesStateViewProps(state: State) -> ContentStateView.Props {
        if state.isEmptyContent {
            return .message(title: .authorRecipesEmptyText, buttonTitle: nil)
        } else if state.isErrorPresent {
            return .message(title: state.recipes.error?.localizedDescription ?? "", buttonTitle: .authorRetry)
        } else {
            return .hidden
        }
    }
}
