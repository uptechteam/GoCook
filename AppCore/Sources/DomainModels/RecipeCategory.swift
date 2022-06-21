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

    public let category: String
    public let recipes: [Recipe]

    // MARK: - Lifecycle

    public init(category: String, recipes: [Recipe]) {
        self.category = category
        self.recipes = recipes
    }
}

extension RecipeCategory: EmptyDomainModel {
    public static var empty: RecipeCategory {
        RecipeCategory(category: "", recipes: [])
    }
}
