//
//  NewIngredient.swift
//  
//
//  Created by Oleksii Andriushchenko on 30.06.2022.
//

import Foundation

public struct NewIngredient: Equatable {

    // MARK: - Properties

    public let id: String
    public var name: String
    public var amount: Int?
    public var unit: IngredientUnit

    public var isValid: Bool {
        !name.isEmpty
    }

    // MARK: - Lifecycle

    public init(id: String, name: String, amount: Int? = nil, unit: IngredientUnit) {
        self.id = id
        self.name = name
        self.amount = amount
        self.unit = unit
    }

    // MARK: - Public methods

    public static func makeNewIngredient() -> NewIngredient {
        .init(id: UUID().uuidString, name: "", amount: nil, unit: .gram)
    }
}
