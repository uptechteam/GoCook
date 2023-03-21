//
//  RecipeProps.swift
//  
//
//  Created by Oleksii Andriushchenko on 15.06.2022.
//

import DomainModels
import Foundation
import Library

extension RecipePresenter {
    static func makeProps(from state: State) -> RecipeView.Props {
        return .init(
            headerViewProps: makeHeaderViewProps(state: state),
            recipeImageSource: state.recipeImageSource,
            isFavorite: state.recipeDetails.isFavorite,
            recipeDetailsViewProps: makeRecipeDetailsViewProps(state: state)
        )
    }

    private static func makeHeaderViewProps(state: State) -> RecipeHeaderView.Props {
        return .init(
            title: state.recipeName,
            isFavorite: state.recipeDetails.isFavorite
        )
    }

    private static func makeRecipeDetailsViewProps(state: State) -> RecipeDetailsView.Props {
        return .init(
            headerViewProps: makeDetailsHeaderViewProps(state: state),
            ingredientsViewProps: makeIngredientsViewProps(state: state),
            instructionsViewProps: makeInstructionsViewProps(state: state),
            feedbackViewProps: makeFeedbackViewProps(state: state),
            manageViewProps: makeManageViewProps(state: state)
        )
    }

    private static func makeDetailsHeaderViewProps(state: State) -> RecipeDetailsHeaderView.Props {
        return .init(
            name: state.recipeName,
            contentStateView: makeContentStateView(state: state),
            authorViewProps: makeAuthorViewProps(state: state),
            isBottomContentVisible: state.recipeDetails.isPresent,
            ratingViewProps: makeRatingViewProps(recipe: state.recipeDetails.getModel()),
            timeViewProps: RecipeTimeView.Props(timeDescription: .recipeDetailsCookingTime(state.recipeDetails.duration))
        )
    }

    private static func makeAuthorViewProps(state: State) -> RecipeAuthorView.Props {
        return .init(
            isVisible: state.recipeDetails.isPresent,
            avatarImageSource: state.recipeDetails.author.avatar,
            username: state.recipeDetails.author.username
        )
    }

    private static func makeRatingViewProps(recipe: RecipeDetails) -> RatingView.Props {
        let reviewsCount = recipe.ratingDetails.reviewsCount
        return .init(
            ratingText: "\(recipe.ratingDetails.rating)",
            isReviewsLabelVisible: true,
            reviewsText: reviewsCount == 1 ? .recipeDetailsOneReview : .recipeDetailsReviews(reviewsCount)
        )
    }

    private static func makeContentStateView(state: State) -> ContentStateView.Props {
        guard state.recipeDetails.isPresent else {
            return .hidden
        }

        if state.recipeDetails.isLoading {
            return .loading
        } else if state.recipeDetails.error != nil {
            return .message(title: .recipeErrorTitle, buttonTitle: .recipeErrorRetry)
        } else {
            return .hidden
        }
    }

    private static func makeIngredientsViewProps(state: State) -> RecipeIngredientsView.Props {
        return .init(
            isVisible: state.recipeDetails.isPresent,
            servingsDescription: makeServingsDescription(state: state),
            ingredientsProps: state.recipeDetails.ingredients.map { ingredient in
                return RecipeIngredientView.Props(
                    name: ingredient.name,
                    weightDescription: "\(ingredient.amount)\(ingredient.unit.reduction)"
                )
            }
        )
    }

    private static func makeServingsDescription(state: State) -> String {
        return state.recipeDetails.servingsCount == 1
        ? .recipeIngredientsOneServing
        : .recipeIngredientsServings(state.recipeDetails.servingsCount)
    }

    private static func makeInstructionsViewProps(state: State) -> RecipeInstructionsView.Props {
        return .init(
            isVisible: state.recipeDetails.isPresent,
            instructionsProps: state.recipeDetails.instructions.enumerated().map { (index, instruction) in
                RecipeInstructionView.Props(title: .recipeInstructionsStepTitle(index + 1), description: instruction)
            }
        )
    }

    private static func makeFeedbackViewProps(state: State) -> RecipeFeedbackView.Props {
        return .init(
            isVisible: state.recipeDetails.isPresent,
            text: state.recipeDetails.rating == nil ? .recipeRatingQuestion(state.recipeName) : .recipeRatingThankYou,
            rating: state.recipeDetails.rating ?? 0
        )
    }

    private static func makeManageViewProps(state: State) -> RecipeManageView.Props {
        return .init(
            isVisible: state.recipeDetails.isPresent,
            isEditButtonVisible: true,
            isDeleteButtonVisible: true
        )
    }
}
