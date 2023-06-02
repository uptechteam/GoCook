//
//  ManageRecipeEnvelope.swift
//  
//
//  Created by Oleksii Andriushchenko on 02.06.2023.
//

import DomainModels

public enum ManageRecipeEnvelope: Equatable {

    case create
    case edit(RecipeDetails)

    var recipe: RecipeDetails? {
        switch self {
        case .create:
            return nil

        case .edit(let recipe):
            return recipe
        }
    }
}
