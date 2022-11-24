//
//  RecipeCategoryResponse.swift
//  
//
//  Created by Oleksii Andriushchenko on 20.06.2022.
//

import DomainModels
import Foundation

struct RecipeCategoryResponse: Decodable {

    // MARK: - Properties

    let name: String
    let recipes: [RecipeResponse]

    // MARK: - Public methods

    func getDomainModel() throws -> RecipeCategory {
        guard let category = CategoryType(name: name) else {
            throw APIError.brokenData
        }

        return RecipeCategory(
            category: category,
            recipes: recipes.map(\.domainModel)
        )
    }
}
