//
//  InputDetails.swift
//  
//
//  Created by Oleksii Andriushchenko on 29.06.2022.
//

public enum InputDetails: Equatable {
    case cookingTime(String)
    case ingredientAmount(text: String, unit: IngredientUnit)
    case ingredientName(String)
    case numberOfServings(String)
}
