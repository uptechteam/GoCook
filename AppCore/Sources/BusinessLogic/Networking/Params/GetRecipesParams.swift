//
//  GetRecipesParams.swift
//  
//
//  Created by Oleksii Andriushchenko on 22.03.2023.
//

import Foundation

struct GetRecipesParams: Encodable {
    let categoryFilters: [String]
    let page: Int
    let pageSize: Int
    let query: String
    let timeFilters: [String]
}
