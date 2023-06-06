//
//  InputProps.swift
//  
//
//  Created by Oleksii Andriushchenko on 28.06.2022.
//

import DomainModels

extension InputPresenter {
    static func makeProps(from state: State) -> InputView.Props {
        return .init(
            title: makeTitle(state: state),
            text: state.text,
            placeholder: makePlaceholder(state: state),
            keyboardType: makeKeyboardType(state: state),
            unitViewProps: makeUnitViewProps(state: state)
        )
    }

    private static func makeTitle(state: State) -> String {
        switch state.inputDetails {
        case .cookingTime:
            return "Cooking time, min"

        case .ingredientAmount:
            return "Ingredient amount"

        case .ingredientName:
            return "Ingredient name"

        case .numberOfServings:
            return "Number of serving"
        }
    }

    private static func makePlaceholder(state: State) -> String {
        guard state.text.isEmpty else {
            return ""
        }

        switch state.inputDetails {
        case .cookingTime, .ingredientAmount, .numberOfServings:
            return "Amount"

        case .ingredientName:
            return "Name"
        }
    }

    private static func makeKeyboardType(state: State) -> InputView.Props.KeyboardType {
        switch state.inputDetails {
        case .cookingTime, .ingredientAmount, .numberOfServings:
            return .numpadPad

        case .ingredientName:
            return .defaultType
        }
    }

    private static func makeUnitViewProps(state: State) -> InputUnitView.Props {
        switch state.inputDetails {
        case .ingredientAmount(_, _, let unit):
            return .init(
                isVisible: state.inputDetails.isUnitPresent,
                text: (state.unit ?? unit).reduction,
                units: IngredientUnit.priorityOrded.map(\.reduction)
            )

        default:
            return .init(isVisible: false, text: "", units: [])
        }
    }
}
