//
//  IngredientRequest.swift
//  
//
//  Created by Oleksii Andriushchenko on 30.06.2022.
//

import Foundation

struct IngredientRequest: Encodable {
    let name: String
    let amount: Int
    let unit: String
}
