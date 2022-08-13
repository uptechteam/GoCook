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
        let trendsSection = makeTrendingSection(state: state)
        let otherCategoriesSections = makeOtherCategoriesSections(state: state)
        return [trendsSection] + otherCategoriesSections
    }

    private static func makeTrendingSection(state: State) -> HomeView.Section {
        let headerProps = RecipeCategoryHeaderView.Props(title: "Trending")
        let items: [HomeView.Item] = [
            .categories(CategoriesCell.Props(items: makeCategoriesCellProps(state: state))),
            .recipes(makeTrendsCategoryCellProps(state: state))
        ]
        return .category(headerProps, items: items)
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

    private static func makeTrendsCategoryCellProps(state: State) -> RecipeCategoryCell.Props {
        guard let trendsCategory = state.recipeCategories.items.first(where: \.isTrendsCategory) else {
            return .init(title: "Trends", items: [])
        }

        return makeRecipeCategoryCellProps(recipeCategory: trendsCategory)
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

    private static func makeOtherCategoriesSections(state: State) -> [HomeView.Section] {
        let otherCategories = state.recipeCategories.items.filter { !$0.isTrendsCategory }
        return otherCategories.map(makeOtherCategorySection)
    }

    private static func makeOtherCategorySection(recipeCategory: RecipeCategory) -> HomeView.Section {
        return .category(
            RecipeCategoryHeaderView.Props(title: recipeCategory.category.name),
            items: [.recipes(makeRecipeCategoryCellProps(recipeCategory: recipeCategory))]
        )
    }
}
