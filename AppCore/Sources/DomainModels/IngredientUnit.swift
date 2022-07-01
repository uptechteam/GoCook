//
//  IngredientUnit.swift
//  
//
//  Created by Oleksii Andriushchenko on 29.06.2022.
//

import Library

public enum IngredientUnit: Equatable {
    case cup
    case gram
    case kilogram
    case liter
    case milliliter
    case pinch
    case tableSpoon
    case teaSpoon
    case whole

    public var reduction: String {
        switch self {
        case .cup:
            return .ingredientUnitCupReduction

        case .gram:
            return .ingredientUnitGramReduction

        case .kilogram:
            return .ingredientUnitKilogramReduction

        case .liter:
            return .ingredientUnitLiterReduction

        case .milliliter:
            return .ingredientUnitMilliliterReduction

        case .pinch:
            return .ingredientUnitPinchReduction

        case .tableSpoon:
            return .ingredientUnitTableSpoonReduction

        case .teaSpoon:
            return .ingredientUnitTeaSpoonReduction

        case .whole:
            return .ingredientUnitWhileReduction
        }
    }

    public static var priorityOrded: [IngredientUnit] = [
        .gram, .milliliter, .teaSpoon, .tableSpoon, .whole, .cup, .pinch, .liter, .kilogram
    ]
}
