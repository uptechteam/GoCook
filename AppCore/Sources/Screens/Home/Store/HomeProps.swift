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
        .init(feedViewProps: makeFeedViewProps(state: state))
    }

    private static func makeFeedViewProps(state: State) -> HomeFeedView.Props {
        return .init(
            trendingCategoryViewProps: makeTrendingCategoryViewProps(state: state),
            otherCategoriesViewsProps: makeOtherCategoriesViewProps(state: state)
        )
    }

    private static func makeTrendingCategoryViewProps(state: State) -> HomeTrendingCategoryView.Props {
        return .init(
            headerProps: HomeRecipeCategoryHeaderView.Props(title: "Trending"),
            categoriesListViewProps: makeCategoriesListViewProps(state: state),
            recipesListViewProps: makeTrendingRecipesListViewProps(state: state)
        )
    }

    private static func makeCategoriesListViewProps(state: State) -> HomeCategoriesListView.Props {
        let allItem = makeCategoryCellProps(title: "All", isSelected: state.selectedCategories.isEmpty)
        let items = CategoryType.priorityOrder.map { type in
            makeCategoryCellProps(title: type.name, isSelected: state.selectedCategories.contains(type))
        }
        return .init(items: [allItem] + items)
    }

    private static func makeCategoryCellProps(title: String, isSelected: Bool) -> CategoryCell.Props {
        return .init(
            backgroundColorSource: isSelected ? .color(.secondaryMain) :  .color(.gray100),
            title: title,
            titleColorSource: isSelected ? .color(.appWhite) : .color(.textMain)
        )
    }

    private static func makeTrendingRecipesListViewProps(state: State) -> HomeRecipesListView.Props {
        let recipes = state.recipeCategories.items.first(where: \.isTrendingCategory)?.recipes ?? []
        return .init(items: recipes.map(makeRecipeCellProps))
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

    private static func makeOtherCategoriesViewProps(state: State) -> [HomeOtherCategoryView.Props] {
        let otherCategories = state.recipeCategories.items.filter { !$0.isTrendingCategory }
        return otherCategories.map(makeOtherCategoryViewProps)
    }

    private static func makeOtherCategoryViewProps(recipeCategory: RecipeCategory) -> HomeOtherCategoryView.Props {
        return .init(
            headerProps: HomeRecipeCategoryHeaderView.Props(title: recipeCategory.category.name),
            recipesListViewProps: HomeRecipesListView.Props(items: recipeCategory.recipes.map(makeRecipeCellProps))
        )
    }
}
