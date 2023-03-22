//
//  GetFavoriteRecipesParams.swift
//  
//
//  Created by Oleksii Andriushchenko on 22.03.2023.
//

import Foundation

struct GetFavoriteRecipesParams: Encodable {
    let categoryFilters: [String]
    let query: String
    let timeFilters: [String]
}
