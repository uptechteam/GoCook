//
//  NewRecipeRequest.swift
//  
//
//  Created by Oleksii Andriushchenko on 30.06.2022.
//

import Foundation

struct NewRecipeRequest: Encodable {
    let name: String
    let imageID: String
    let duration: Int
    let tags: [String]
    let ingredients: [IngredientRequest]
    let servings: Int
    let instructions: [String]
}
