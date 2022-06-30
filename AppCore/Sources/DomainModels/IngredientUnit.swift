//
//  Unit.swift
//  
//
//  Created by Oleksii Andriushchenko on 29.06.2022.
//

import Foundation

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
            return "cup"

        case .gram:
            return "g"

        case .kilogram:
            return "kg"

        case .liter:
            return "liter"

        case .milliliter:
            return "ml"

        case .pinch:
            return "pinch"

        case .tableSpoon:
            return "tbsp"

        case .teaSpoon:
            return "tsp"

        case .whole:
            return "whole"
        }
    }

    public static var priorityOrded: [IngredientUnit] = [
        .gram, .milliliter, .teaSpoon, .tableSpoon, .whole, .cup, .pinch, .liter, .kilogram
    ]
}
