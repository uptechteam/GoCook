//
//  InputDetails.swift
//  
//
//  Created by Oleksii Andriushchenko on 29.06.2022.
//

public enum InputDetails: Equatable {
    case cookingTime(String)
    case ingredientAmount(id: String, amount: String, unit: IngredientUnit)
    case ingredientName(id: String, name: String)
    case numberOfServings(String)
}
