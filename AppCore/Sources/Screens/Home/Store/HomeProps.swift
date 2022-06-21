//
//  HomeProps.swift
//  
//
//  Created by Oleksii Andriushchenko on 13.06.2022.
//

import DomainModels
import Library

extension HomeViewController {
    static func makeProps(from state: State) -> HomeView.Props {
        .init(items: state.recipeCategories.items.map(makeRecipeCategoryCellProps))
    }

    private static func makeRecipeCategoryCellProps(recipeCategory: RecipeCategory) -> RecipeCategoryCell.Props {
        return .init(
            title: recipeCategory.category,
            items: recipeCategory.recipes.map(makeRecipeCellProps)
        )
    }

    private static func makeRecipeCellProps(recipe: Recipe) -> RecipeCell.Props {
        return .init(
            id: recipe.id.rawValue,
            recipeImageSource: recipe.recipeImageSource,
            isLiked: false,
            name: recipe.name,
            ratingViewProps: RatingView.Props(ratingText: "\(recipe.rating)")
        )
    }
}
