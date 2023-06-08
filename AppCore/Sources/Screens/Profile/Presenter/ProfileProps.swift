//
//  ProfileProps.swift
//  
//
//  Created by Oleksii Andriushchenko on 15.06.2022.
//

import DomainModels
import Library

extension ProfilePresenter {
    static func makeProps(from state: State) -> ProfileView.Props {
        return .init(
            headerViewProps: makeHeaderViewProps(state: state),
            recipesHeaderViewProps: makeRecipesHeaderViewProps(state: state),
            isCollectionViewVisible: !state.recipes.items.isEmpty || state.recipes.isLoading,
            collectionViewProps: makeCollectionViewProps(state: state),
            profileStateView: makeProfileStateView(state: state)
        )
    }

    private static func makeHeaderViewProps(state: State) -> ProfileHeaderView.Props {
        return .init(
            isEditButtonVisible: state.profile != nil,
            isSettingsButtonVisible: state.profile != nil,
            avatarImageSource: state.profile?.avatar ?? .asset(.avatarPlaceholder),
            isSignInButtonVisible: state.profile == nil,
            isNameLabelVisible: state.profile != nil,
            name: state.profile?.username ?? ""
        )
    }

    private static func makeRecipesHeaderViewProps(state: State) -> ProfileRecipesHeaderView.Props {
        .init(isAddNewButtonVisible: !state.recipes.items.isEmpty)
    }

    private static func makeCollectionViewProps(state: State) -> CollectionView<Int, ProfileView.Item>.Props {
        let isShimmeringVisible = state.recipes.isEmpty && state.recipes.isLoading
        return .init(
            section: [0],
            items: [isShimmeringVisible ? makeShimmeringItems() : makeItems(state: state)],
            isRefreshing: state.recipes.isLoading
        )
    }

    private static func makeShimmeringItems() -> [ProfileView.Item] {
        return [
            ProfileView.Item.shimmering(0),
            ProfileView.Item.shimmering(1),
            ProfileView.Item.shimmering(2)
        ]
    }

    private static func makeItems(state: State) -> [ProfileView.Item] {
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
            .map(ProfileView.Item.recipe)
    }

    private static func makeProfileStateView(state: State) -> ContentStateView.Props {
        if state.isEmptyContent {
            return .message(title: .profileStateEmptyTitle, buttonTitle: .profileStateEmptyButton)
        } else if state.isErrorPresent {
            return .message(
                title: state.recipes.error?.localizedDescription ?? "",
                buttonTitle: .profileStateErrorButton
            )
        } else if state.isNotSignedIn {
            return .message(title: .profileNotSignedInTitle, buttonTitle: nil)
        } else {
            return .hidden
        }
    }
}
