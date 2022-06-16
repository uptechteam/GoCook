//
//  RecipeProps.swift
//  
//
//  Created by Oleksii Andriushchenko on 15.06.2022.
//

import Foundation

extension RecipeViewController {
    static func makeProps(from state: State) -> RecipeView.Props {
        .init(recipeImageSource: state.recipe.recipeImageSource)
    }
}
