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
}
