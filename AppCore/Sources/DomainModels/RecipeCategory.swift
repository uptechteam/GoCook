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

    public let category: CategoryType
    public let recipes: [Recipe]

    // MARK: - Lifecycle

    public init(category: CategoryType, recipes: [Recipe]) {
        self.category = category
        self.recipes = recipes
    }
}

extension RecipeCategory: EmptyDomainModel {
    public static var empty: RecipeCategory {
        RecipeCategory(category: .custom(name: "Trends"), recipes: [])
    }
}
