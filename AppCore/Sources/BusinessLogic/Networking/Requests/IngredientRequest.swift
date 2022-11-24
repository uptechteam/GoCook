//
//  IngredientRequest.swift
//  
//
//  Created by Oleksii Andriushchenko on 30.06.2022.
//

import DomainModels

struct IngredientRepresentable: Codable {

    // MARK: - Properties

    let amount: Int
    let name: String
    let unit: String

    var domainModel: Ingredient {
        .init(amount: amount, name: name, unit: IngredientUnit(rawValue: unit) ?? .gram)
    }

    // MARK: - Lifecycle

    init?(newIngredient: NewIngredient) {
        guard let amount = newIngredient.amount else {
            return nil
        }

        self.amount = amount
        self.name = newIngredient.name
        self.unit = newIngredient.unit.reduction
    }
}
