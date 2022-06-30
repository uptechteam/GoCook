//
//  NewRecipe.swift
//  
//
//  Created by Oleksii Andriushchenko on 30.06.2022.
//

import Foundation

public struct NewRecipe: Equatable {

    // MARK: - Properties

    public let duration: Int
    public let imageID: String
    public let ingredients: [NewIngredient]
    public let instructions: [String]
    public let name: String
    public let servings: Int
    public let tags: [CategoryType]
}
