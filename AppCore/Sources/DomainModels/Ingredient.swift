//
//  Ingredient.swift
//  
//
//  Created by Oleksii Andriushchenko on 16.06.2022.
//

public struct Ingredient: Equatable {

    // MARK: - Properties

    public let amount: Int
    public let name: String
    public let unit: IngredientUnit

    // MARK: - Lifecycle

    public init(amount: Int, name: String, unit: IngredientUnit) {
        self.amount = amount
        self.name = name
        self.unit = unit
    }
}
