//
//  FeedProps.swift
//  
//
//  Created by Oleksii Andriushchenko on 13.06.2022.
//

import DomainModels

extension FeedViewController {
    static func makeProps(from state: State) -> FeedView.Props {
        .init(items: state.recipeCategories.map(makeRecipeCategoryCellProps))
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
