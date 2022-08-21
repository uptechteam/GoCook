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
        let all = makeCategoryCellProps(title: "All", isSelected: state.selectedCategories.isEmpty)
        let categories = CategoryType.priorityOrder.map { type in
            makeCategoryCellProps(title: type.name, isSelected: state.selectedCategories.contains(type))
        }
        return [all] + categories
    }

    private static func makeCategoryCellProps(title: String, isSelected: Bool) -> CategoryCell.Props {
        return .init(
            backgroundColorSource: isSelected ? .color(.secondaryMain) :  .color(.gray100),
            title: title,
            titleColorSource: isSelected ? .color(.appWhite) : .color(.textMain)
        )
    }

    private static func makeTrendsCategoryCellProps(state: State) -> RecipeCategoryCell.Props {
        guard let trendsCategory = state.recipeCategories.items.first(where: \.isTrendingCategory) else {
            return .init(title: "Trending", items: [])
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
        let otherCategories = state.recipeCategories.items.filter { !$0.isTrendingCategory }
        return otherCategories.map(makeOtherCategorySection)
    }

    private static func makeOtherCategorySection(recipeCategory: RecipeCategory) -> HomeView.Section {
        return .category(
            RecipeCategoryHeaderView.Props(title: recipeCategory.category.name),
            items: [.recipes(makeRecipeCategoryCellProps(recipeCategory: recipeCategory))]
        )
    }
}
