//
//  InputDetails.swift
//  
//
//  Created by Oleksii Andriushchenko on 29.06.2022.
//

public enum InputDetails: Equatable {
    case cookingTime(String)
    case ingredientAmount(id: String, amount: String, unit: IngredientUnit)
    case ingredientName(id: String, name: String)
    case numberOfServings(String)

    public var isUnitPresent: Bool {
        switch self {
        case .ingredientAmount:
            return true

        default:
            return false
        }
    }

    public var text: String {
        switch self {
        case .cookingTime(let text):
            return text

        case .ingredientAmount(_, let amount, _):
            return amount

        case .ingredientName(_, let name):
            return name

        case .numberOfServings(let text):
            return text
        }
    }
}
