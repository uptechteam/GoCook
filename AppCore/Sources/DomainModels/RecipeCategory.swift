//
//  RecipeCategory.swift
//  
//
//  Created by Oleksii Andriushchenko on 15.06.2022.
//

import Foundation
import Helpers

public struct RecipeCategory: Equatable {

    // MARK: - Properties

    public let recipes: [Recipe]
    public let type: CategoryType

    public var isTrendingCategory: Bool {
        type == .trending
    }

    // MARK: - Lifecycle

    public init(recipes: [Recipe], category: CategoryType) {
        self.recipes = recipes
        self.type = category
    }
}

// MARK: - EmptyDomainModel

extension RecipeCategory: EmptyDomainModel {
    public static var empty: RecipeCategory {
        RecipeCategory(recipes: [], category: .trending)
    }
}
