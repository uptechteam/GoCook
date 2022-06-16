//
//  Ingredient.swift
//  
//
//  Created by Oleksii Andriushchenko on 16.06.2022.
//

public struct Ingredient: Equatable {

    // MARK: - Properties

    public let name: String
    /// Weight in grams
    public let weight: Int

    // MARK: - Lifecycle

    public init(name: String, weight: Int) {
        self.name = name
        self.weight = weight
    }
}
