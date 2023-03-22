//
//  RecipeFilters.swift
//  
//
//  Created by Oleksii Andriushchenko on 22.03.2023.
//

import Foundation

public struct RecipeFilters: Equatable {

    // MARK: - Properties

    public let categories: [CategoryType]
    public let timeFilters: [RecipeTimeFilter]

    // MARK: - Lifecycle

    public init(categories: [CategoryType], timeFilters: [RecipeTimeFilter]) {
        self.categories = categories
        self.timeFilters = timeFilters
    }
}
