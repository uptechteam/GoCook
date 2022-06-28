//
//  RecipeCategoryResponse.swift
//  
//
//  Created by Oleksii Andriushchenko on 20.06.2022.
//

import DomainModels
import Foundation

struct RecipeCategoryResponse: Decodable {
    let name: String
    let recipes: [RecipeResponse]

    var domainModel: RecipeCategory {
        RecipeCategory(
            category: CategoryType(name: name),
            recipes: recipes.map(\.domainModel)
        )
    }
}
