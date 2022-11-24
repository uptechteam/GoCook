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
            return .ingredientUnitWholeReduction
        }
    }

    public static var priorityOrded: [IngredientUnit] = [
        .gram, .milliliter, .teaSpoon, .tableSpoon, .whole, .cup, .pinch, .liter, .kilogram
    ]

    // MARK: - Lifecycle

    public init?(rawValue: String) {
        switch rawValue {
        case "cup":
            self = .cup

        case "gr":
            self = .gram

        case "kg":
            self = .kilogram

        case "liter":
            self = .liter

        case "ml":
            self = .milliliter

        case "pinch":
            self = .pinch

        case "tbsp":
            self = .tableSpoon

        case "tsp":
            self = .teaSpoon

        case "whole":
            self = .whole

        default:
            return nil
        }
    }
}
