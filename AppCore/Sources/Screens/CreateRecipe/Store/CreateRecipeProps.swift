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

    private static func makeStepOneViewProps(state: State) -> CreateRecipeStepOneView.Props {
        return .init(
            isVisible: state.step == 0,
            recipeImageViewProps: makeRecipeImageViewProps(state: state),
            mealNameInputViewProps: makeMealNameInputViewProps(state: state),
            items: makeCategoryItems(state: state),
            isCategoryErrorLabelVisible: !state.stepOneState.areCategoriesValid
        )
    }

    private static func makeRecipeImageViewProps(state: State) -> RecipeImageView.Props {
        return .init(
            recipeImageSource: state.stepOneState.recipeImageState.uploadedImageSource,
            isThreeDostImageViewVisible: state.stepOneState.recipeImageState.uploadedImageSource != nil,
            isLoaderVisible: state.stepOneState.recipeImageState.isUploading,
            errorViewProps: ErrorView.Props(isVisible: !state.stepOneState.isRecipeImageValid, message: "Upload meal photo")
        )
    }

    private static func makeMealNameInputViewProps(state: State) -> InputView.Props {
        let isValid = state.stepOneState.isMealNameValid
        return .init(
            title: "MEAL NAME",
            titleColorSource: .color(isValid ? .textSecondary : .errorMain),
            dividerColorSource: .color(isValid ? .appBlack : .errorMain),
            errorMessage: isValid ? "" : "Enter meal name",
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

    private static func makeStepTwoViewProps(state: State) -> CreateRecipeStepTwoView.Props {
        .init(isVisible: state.step == 1)
    }

    private static func makeStepThreeViewProps(state: State) -> CreateRecipeStepThreeView.Props {
        .init(isVisible: state.step == 2)
    }

    private static func makeStepFourViewProps(state: State) -> CreateRecipeStepFourView.Props {
        .init(isVisible: state.step == 3)
    }

    private static func makeStepsViewProps(state: State) -> CreateRecipeStepsView.Props {
        return .init(title: "\(state.step + 1) / 4")
    }
}
