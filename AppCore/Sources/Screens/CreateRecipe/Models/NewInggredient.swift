//
//  NewIngredient.swift
//  
//
//  Created by Oleksii Andriushchenko on 30.06.2022.
//

import DomainModels
import Foundation

struct NewIngredient: Equatable {
    let id: String
    var name: String
    var amount: Int?
    var unit: IngredientUnit

    var isValid: Bool {
        !name.isEmpty
    }

    static func makeNewIngredient() -> NewIngredient {
        .init(id: UUID().uuidString, name: "", amount: nil, unit: .gram)
    }
}
