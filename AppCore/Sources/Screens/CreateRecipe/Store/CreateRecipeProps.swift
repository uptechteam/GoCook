//
//  CreateRecipeProps.swift
//  
//
//  Created by Oleksii Andriushchenko on 23.06.2022.
//

import DomainModels
import Helpers
import Library
import UIKit

extension CreateRecipeViewController {
    static func makeProps(from state: State) -> CreateRecipeView.Props {
        return .init(
            stepOneViewProps: makeStepOneViewProps(state: state),
            stepTwoViewProps: makeStepTwoViewProps(state: state),
            stepThreeViewProps: makeStepThreeViewProps(state: state),
            stepFourViewProps: makeStepFourViewProps(state: state),
            stepsViewProps: makeStepsViewProps(state: state)
        )
    }

    private static func makeStepOneViewProps(state: State) -> StepOneView.Props {
        return .init(
            isVisible: state.step == 0,
            errorViewProps: ErrorView.Props(
                isVisible: state.stepOneState.recipeImageState.errorMessage != nil,
                message: state.stepOneState.recipeImageState.errorMessage ?? ""
            ),
            recipeViewProps: makeRecipeViewProps(state: state),
            mealNameInputViewProps: makeMealNameInputViewProps(state: state),
            items: makeCategoryItems(state: state),
            isCategoryErrorLabelVisible: !state.stepOneState.areCategoriesValid
        )
    }

    private static func makeRecipeViewProps(state: State) -> StepOneRecipeView.Props {
        return .init(
            recipeImageSource: state.stepOneState.recipeImageState.uploadedImageSource,
            isThreeDostImageViewVisible: state.stepOneState.recipeImageState.uploadedImageSource != nil,
            isLoaderVisible: state.stepOneState.recipeImageState.isUploading,
            errorViewProps: makeRecipeErrorViewProps(state: state)
        )
    }

    private static func makeRecipeErrorViewProps(state: State) -> ErrorView.Props {
        return ErrorView.Props(
            isVisible: !state.stepOneState.isRecipeImageValid,
            message: .createRecipeStepOnePhotoValidation
        )
    }

    private static func makeMealNameInputViewProps(state: State) -> UserInputView.Props {
        let isValid = state.stepOneState.isMealNameValid
        return .init(
            title: .createRecipeStepOneMealTitle,
            titleColorSource: .color(isValid ? .textSecondary : .errorMain),
            dividerColorSource: .color(isValid ? .appBlack : .errorMain),
            errorMessage: isValid ? "" : .createRecipeStepOneMealValidation,
            isErrorMessageVisible: !isValid
        )
    }

    private static func makeCategoryItems(state: State) -> [CategoryCell.Props] {
        CategoryType.priorityOrder.map { category in
            CategoryCell.Props(
                name: category.name,
                nameColorSource: .color(state.stepOneState.areCategoriesValid ? .textMain : .errorMain),
                checkmarkImageSource: makeCheckmarkImageSource(state: state, category: category)
            )
        }
    }

    private static func makeCheckmarkImageSource(state: State, category: CategoryType) -> ImageSource {
        if state.stepOneState.categories.contains(category) {
            return .asset(.filledCheckbox)
        } else if state.stepOneState.areCategoriesValid {
            return .asset(.emptyCheckbox)
        } else {
            return .asset(.errorCheckbox)
        }
    }

    private static func makeStepTwoViewProps(state: State) -> StepTwoView.Props {
        .init(
            isVisible: state.step == 1,
            servingsViewProps: makeServingsViewProps(state: state),
            ingredientsViewProps: makeIngredientsViewProps(state: state)
        )
    }

    private static func makeServingsViewProps(state: State) -> StepTwoServingsView.Props {
        return .init(
            amountText: state.stepTwoState.numberOfServings.flatMap(String.init) ?? .createRecipeStepTwoServingsPlaceholder,
            amountColorSource: makeAmountColorSource(state: state),
            amountTypography: state.stepTwoState.numberOfServings == nil ? .body : .subtitleThree
        )
    }

    private static func makeAmountColorSource(state: State) -> ColorSource {
        if !state.stepTwoState.isNumberOfServingsValid {
            return .color(.errorMain)
        } else if state.stepTwoState.numberOfServings == nil {
            return .color(.textSecondary)
        } else {
            return .color(.textMain)
        }
    }

    private static func makeIngredientsViewProps(state: State) -> StepTwoIngredientsView.Props {
        return .init(
            items: state.stepTwoState.ingredients.map { ingredient in
                makeIngredientCellProps(state: state, ingredient: ingredient)
            }
        )
    }

    private static func makeIngredientCellProps(state: State, ingredient: NewIngredient) -> IngredientCell.Props {
        return .init(
            id: ingredient.id,
            name: ingredient.name.isEmpty ? .createRecipeStepTwoIngredientsName : ingredient.name,
            nameColorSource: makeIngredientNameColorSource(state: state, ingredient: ingredient),
            nameTypography: ingredient.name.isEmpty ? .body : .subtitleThree,
            amount: makeIngredientAmountText(ingredient: ingredient),
            amountColorSource: makeIngredientAmountColorSource(state: state, ingredient: ingredient),
            amountTypography: ingredient.amount == nil ? .body : .subtitleThree,
            isDeleteImageViewVisible: state.stepTwoState.ingredients.count > 1
        )
    }

    private static func makeIngredientNameColorSource(state: State, ingredient: NewIngredient) -> ColorSource {
        if !ingredient.name.isEmpty {
            return .color(.textMain)
        } else if !state.stepTwoState.areIngredientsValid {
            return .color(.errorMain)
        } else {
            return .color(.textSecondary)
        }
    }

    private static func makeIngredientAmountText(ingredient: NewIngredient) -> String {
        guard let amount = ingredient.amount else {
            return .createRecipeStepTwoIngredientsAmount
        }

        return "\(amount) \(ingredient.unit.reduction)"
    }

    private static func makeIngredientAmountColorSource(state: State, ingredient: NewIngredient) -> ColorSource {
        if ingredient.amount != nil {
            return .color(.textMain)
        } else if !state.stepTwoState.areIngredientsValid {
            return .color(.errorMain)
        } else {
            return .color(.textSecondary)
        }
    }

    private static func makeStepThreeViewProps(state: State) -> StepThreeView.Props {
        return .init(
            isVisible: state.step == 2,
            timeViewProps: makeTimeViewProps(state: state),
            instructionsViewProps: makeInstructionsViewProps(state: state)
        )
    }

    private static func makeTimeViewProps(state: State) -> StepThreeTimeView.Props {
        return .init(
            timeText: state.stepThreeState.cookingTime.flatMap(String.init) ?? .createRecipeStepThreeTimePlaceholder,
            timeColorSource: makeCookingTimeColorSource(state: state),
            timeTypography: state.stepThreeState.cookingTime == nil ? .body : .subtitleThree
        )
    }

    private static func makeInstructionsViewProps(state: State) -> StepThreeInstructionsView.Props {
        return .init(
            instructionsProps: state.stepThreeState.instructions
                .enumerated()
                .map { index, _ in
                    return makeInstructionViewProps(state: state, index: index)
                }
        )
    }

    private static func makeInstructionViewProps(state: State, index: Int) -> StepThreeInstructionView.Props {
        let areInstructionsValid = state.stepThreeState.areInstructionsValid
        let instruction = state.stepThreeState.instructions[index]
        return StepThreeInstructionView.Props(
            title: .createRecipeStepThreeStepTitle(index + 1),
            titleColorSource: .color(areInstructionsValid || !instruction.isEmpty ? .textSecondary : .errorMain),
            text: instruction,
            dividerColorSource: .color(areInstructionsValid || !instruction.isEmpty ? .appBlack : .errorMain),
            errorMessage: .createRecipeStepThreeStepValidation(index + 1),
            isErrorMessageVisible: !areInstructionsValid && instruction.isEmpty,
            isDeleteButtonVisible: state.stepThreeState.instructions.count > 1
        )
    }

    private static func makeCookingTimeColorSource(state: State) -> ColorSource {
        if state.stepThreeState.cookingTime != nil {
            return .color(.textMain)
        } else if !state.stepThreeState.isCookingTimeValid {
            return .color(.errorMain)
        } else {
            return .color(.textSecondary)
        }
    }

    private static func makeStepFourViewProps(state: State) -> StepFourView.Props {
        return .init(
            isVisible: state.step == 3,
            headerViewProps: makeStepFourHeaderViewProps(state: state),
            ingredientsViewProps: makeIngredientsViewProps(state: state),
            instructionsViewProps: makeRecipeInstructionsViewProps(state: state)
        )
    }

    private static func makeStepFourHeaderViewProps(state: State) -> StepFourHeaderView.Props {
        return .init(
            recipeImageSource: .asset(state.stepOneState.recipeImageState.uploadedImageSource?.image),
            name: state.stepOneState.mealName,
            timeViewProps: makeTimeViewProps(state: state)
        )
    }

    private static func makeTimeViewProps(state: State) -> RecipeTimeView.Props {
        .init(timeDescription: .createRecipeStepThreeTimeText(state.stepThreeState.cookingTime ?? 0))
    }

    private static func makeIngredientsViewProps(state: State) -> RecipeIngredientsView.Props {
        return .init(
            servingsDescription: .recipeIngredientsServings(state.stepTwoState.numberOfServings ?? 0),
            ingredientsProps: state.stepTwoState.ingredients.map { ingredient in
                RecipeIngredientView.Props(
                    name: ingredient.name,
                    weightDescription: "\(ingredient.amount ?? 0) \(ingredient.unit.reduction)"
                )
            }
        )
    }

    private static func makeRecipeInstructionsViewProps(state: State) -> RecipeInstructionsView.Props {
        return .init(instructionsProps: state.stepThreeState.instructions.enumerated().map { index, instruction in
            return RecipeInstructionView.Props(title: .recipeInstructionsStepTitle(index + 1), description: instruction)
        })
    }

    private static func makeStepsViewProps(state: State) -> CreateRecipeStepsView.Props {
        return .init(
            title: .createRecipeNavigationTitle(state.step + 1),
            isNextButtonVisible: state.step != 3,
            isFinishButtonVisible: state.step == 3 && !state.isUploadingRecipe,
            isLoaderVisible: state.isUploadingRecipe
        )
    }
}
