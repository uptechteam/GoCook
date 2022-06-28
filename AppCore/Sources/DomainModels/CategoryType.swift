//
//  CategoryType.swift
//  
//
//  Created by Oleksii Andriushchenko on 27.06.2022.
//

import Foundation

public enum CategoryType: Hashable {

    // MARK: - Properties

    case breakfast
    case desserts
    case dinner
    case drinks
    case lunch
    case custom(name: String)

    public var name: String {
        switch self {
        case .breakfast:
            return "Breakfast"

        case .desserts:
            return "Desserts"

        case .dinner:
            return "Dinner"

        case .drinks:
            return "Drinks"

        case .lunch:
            return "Lunch"

        case .custom(let name):
            return name
        }
    }

    public static var priorityOrder: [CategoryType] {
        return [.breakfast, .lunch, .dinner, .desserts, .drinks]
    }

    // MARK: - Lifecycle

    public init(name: String) {
        switch name {
        case "breakfast":
            self = .breakfast

        case "desserts":
            self = .desserts

        case "dinner":
            self = .dinner

        case "drinks":
            self = .drinks

        case "lunch":
            self = .lunch

        default:
            self = .custom(name: name)
        }
    }
}
