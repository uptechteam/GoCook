//
//  CreateRecipeProps.swift
//  
//
//  Created by Oleksii Andriushchenko on 23.06.2022.
//

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
        .init(isVisible: state.step == 0)
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
