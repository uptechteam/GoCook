//
//  InputProps.swift
//  
//
//  Created by Oleksii Andriushchenko on 28.06.2022.
//

extension InputViewController {
    static func makeProps(from state: State) -> InputView.Props {
        return .init(
            title: makeTitle(state: state),
            placeholder: makePlaceholder(state: state)
        )
    }

    private static func makeTitle(state: State) -> String {
        switch state.inputDetails {
        case .ingredientAmount:
            return "Ingredient amount"

        case .ingredientName:
            return "Ingredient name"

        case .numberOfServings:
            return "Number of serving"

        default:
            return "Not implemented"
        }
    }

    private static func makePlaceholder(state: State) -> String {
        switch state.inputDetails {
        case .ingredientAmount, .numberOfServings:
            return "Amount"

        case .ingredientName:
            return "Name"

        default:
            return "Not implemented"
        }
    }
}
