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
        .init(sections: makeSections(state: state))
    }

    private static func makeSections(state: State) -> [HomeView.Section] {
        let categories: [HomeView.Item] = [.categories(CategoriesCell.Props(items: makeCategoriesCellProps(state: state)))]
        let recipeCategories = state.recipeCategories.items.map(makeRecipeCategoryCellProps).map(HomeView.Item.recipes)
        return categories + recipeCategories
    }

    private static func makeCategoriesCellProps(state: State) -> [CategoryCell.Props] {
        let all = CategoryCell.Props(
            backgroundColorSource: .color(.secondaryMain),
            title: "All",
            titleColorSource: .color(.appWhite)
        )
        let categories = CategoryType.priorityOrder.map { type in
            return CategoryCell.Props(
                backgroundColorSource: .color(.gray100),
                title: type.name,
                titleColorSource: .color(.textMain)
            )
        }
        return [all] + categories
    }

    private static func makeRecipeCategoryCellProps(recipeCategory: RecipeCategory) -> RecipeCategoryCell.Props {
        return .init(
            title: recipeCategory.category.name,
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
