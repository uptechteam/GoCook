//
//  ProfileProps.swift
//  
//
//  Created by Oleksii Andriushchenko on 15.06.2022.
//

import DomainModels
import Library

extension ProfileViewController {
    static func makeProps(from state: State) -> ProfileView.Props {
        .init(
            headerViewProps: makeHeaderViewProps(state: state),
            recipesHeaderViewProps: makeRecipesHeaderViewProps(state: state),
            isCollectionViewVisible: !state.recipes.items.isEmpty,
            items: makeItems(state: state),
            infoViewProps: makeInfoViewProps(state: state)
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

    private static func makeItems(state: State) -> [ProfileRecipeCell.Props] {
        return state.recipes.items.map { recipe in
            return ProfileRecipeCell.Props(
                id: recipe.id.rawValue,
                recipeImageSource: recipe.recipeImageSource,
                favoriteImageSource: .asset(recipe.isFavorite ? .circleWithFilledHeart : .circleWithEmptyHeart),
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

    private static func makeInfoViewProps(state: State) -> ProfileInfoView.Props {
        return .init(
            isVisible: state.recipes.items.isEmpty,
            description: state.profile == nil ? .profileNotSignedInTitle : .profileEmptyContentTitle,
            isAddRecipeButtonVisible: state.profile != nil
        )
    }
}
