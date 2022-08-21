//
//  CategoryType.swift
//  
//
//  Created by Oleksii Andriushchenko on 27.06.2022.
//

import Foundation
import Helpers

public enum CategoryType: Hashable {

    // MARK: - Properties

    case breakfast
    case desserts
    case dinner
    case drinks
    case lunch
    case trending

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

        case .trending:
            return "Trending"
        }
    }

    public static var priorityOrder: [CategoryType] {
        return [.breakfast, .lunch, .dinner, .desserts, .drinks]
    }

    // MARK: - Lifecycle

    public init?(name: String) {
        switch name {
        case "Breakfast":
            self = .breakfast

        case "Desserts":
            self = .desserts

        case "Dinner":
            self = .dinner

        case "Drinks":
            self = .drinks

        case "Lunch":
            self = .lunch

        case "Trending":
            self = .trending

        default:
            log.error("Got invalid value for category type", metadata: ["Value": .string(name)])
            return nil
        }
    }
}
