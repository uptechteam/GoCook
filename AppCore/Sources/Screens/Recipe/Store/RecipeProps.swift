//
//  RecipeProps.swift
//  
//
//  Created by Oleksii Andriushchenko on 15.06.2022.
//

import Foundation
import Library

extension RecipeViewController {
    static func makeProps(from state: State) -> RecipeView.Props {
        return .init(
            recipeImageSource: state.recipe.recipeImageSource,
            isLiked: false,
            recipeDetailsViewProps: makeRecipeDetailsViewProps(state: state)
        )
    }

    private static func makeRecipeDetailsViewProps(state: State) -> RecipeDetailsView.Props {
        return .init(
            headerViewProps: makeHeaderViewProps(state: state),
            ingredientsViewProps: makeIngredientsViewProps(state: state),
            instructionsViewProps: makeInstructionsViewProps(state: state),
            feedbackViewProps: makeFeedbackViewProps(state: state)
        )
    }

    private static func makeHeaderViewProps(state: State) -> RecipeDetailsHeaderView.Props {
        return .init(
            name: state.recipe.name,
            authorViewProps: RecipeAuthorView.Props(avatarImageSource: .asset(nil), username: "Monica Adams"),
            ratingViewProps: RatingView.Props(ratingText: "4.8"),
            timeViewProps: RecipeTimeView.Props(timeDescription: "30 min")
        )
    }

    private static func makeIngredientsViewProps(state: State) -> RecipeIngredientsView.Props {
        return .init(
            servingsDescription: "4 servings",
            ingredientsProps: [
                RecipeIngredientView.Props(name: "Sliced avocado", weightDescription: "200g"),
                RecipeIngredientView.Props(name: "Tortilla chips", weightDescription: "300g"),
                RecipeIngredientView.Props(name: "Romaine lettuce", weightDescription: "400g"),
                RecipeIngredientView.Props(name: "Red cabbage and radishes", weightDescription: "150g"),
                RecipeIngredientView.Props(name: "A little\nlove", weightDescription: "100g")
            ]
        )
    }

    private static func makeInstructionsViewProps(state: State) -> RecipeInstructionsView.Props {
        return .init(
            instructionsProps: [
                RecipeInstructionView.Props(
                    title: "1 step",
                    description: "Eleifend tristique duis laoreet phasellus praesent. Nulla sed vitae sed id."
                ),
                RecipeInstructionView.Props(
                    title: "2 step",
                    description: "Eleifend tristique duis laoreet phasellus praesent. Nulla sed vitae sed id."
                ),
                RecipeInstructionView.Props(
                    title: "3 step",
                    description: "Eleifend tristique duis laoreet phasellus praesent. Nulla sed vitae sed id."
                )
            ]
        )
    }

    private static func makeFeedbackViewProps(state: State) -> RecipeFeedbackView.Props {
        .init(text: "How would you rate Grilled Corn With Chaat Masala?", rating: 3)
    }
}
