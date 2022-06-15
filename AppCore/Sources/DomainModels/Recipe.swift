//
//  File.swift
//  
//
//  Created by Oleksii Andriushchenko on 15.06.2022.
//

import Helpers

struct Recipe: Equatable {
    typealias ID = Tagged<Recipe, String>

    let id: ID
    let name: String
    let avatarImageSource: ImageSource
    let rating: Double
}
