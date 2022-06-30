//
//  IngredientRequest.swift
//  
//
//  Created by Oleksii Andriushchenko on 30.06.2022.
//

import DomainModels

struct IngredientRequest: Encodable {

    // MARK: - Properties

    let amount: Int
    let name: String
    let unit: String

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
