//
//  StepTwoState.swift
//  
//
//  Created by Oleksii Andriushchenko on 28.06.2022.
//

import DomainModels
import Foundation

struct StepTwoState: Equatable {

    // MARK: - Properties

    var numberOfServings: Int?
    var ingredients: [NewIngredient]
}

struct NewIngredient: Equatable {
    let id: String
    let name: String
}
