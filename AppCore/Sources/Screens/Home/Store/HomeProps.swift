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
        return .init(
            feedViewProps: makeFeedViewProps(state: state),
            searchResultsViewProps: makeSearchResultsViewProps(state: state)
        )
    }

    private static func makeFeedViewProps(state: State) -> HomeFeedView.Props {
        return .init(
            isVisible: state.searchQuery.isEmpty,
            trendingCategoryViewProps: makeTrendingCategoryViewProps(state: state),
            otherCategoriesViewsProps: state.otherCategories.map(makeOtherCategoryViewProps)
        )
    }

    private static func makeTrendingCategoryViewProps(state: State) -> HomeTrendingCategoryView.Props {
        return .init(
            headerProps: HomeRecipeCategoryHeaderView.Props(title: "Trending"),
            categoriesListViewProps: makeCategoriesListViewProps(state: state),
            recipesListViewProps: makeRecipesListViewProps(category: state.trendingCategory)
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

    private static func makeOtherCategoryViewProps(recipeCategory: RecipeCategory) -> HomeOtherCategoryView.Props {
        return .init(
            headerProps: HomeRecipeCategoryHeaderView.Props(title: recipeCategory.category.name),
            recipesListViewProps: makeRecipesListViewProps(category: recipeCategory)
        )
    }

    private static func makeSearchResultsViewProps(state: State) -> HomeSearchResultsView.Props {
        return .init(
            isVisible: !state.searchQuery.isEmpty,
            items: state.isGettingRecipes ? [] : state.searchedRecipes.map(makeSmallRecipeCellProps),
            isSpinnerVisible: state.isGettingRecipes,
            isNoResultsLabelVisible: !state.isGettingRecipes && state.searchedRecipes.isEmpty
        )
    }

    // MARK: - Extra

    private static func makeRecipesListViewProps(category: RecipeCategory) -> HomeRecipesListView.Props {
        .init(items: category.recipes.map(makeRecipeCellProps))
    }

    private static func makeRecipeCellProps(recipe: Recipe) -> RecipeCell.Props {
        return .init(
            id: recipe.id.rawValue,
            recipeImageSource: recipe.recipeImageSource,
            isLiked: recipe.isFavorite,
            name: recipe.name,
            ratingViewProps: RatingView.Props(ratingText: "\(recipe.rating)")
        )
    }

    private static func makeSmallRecipeCellProps(recipe: Recipe) -> SmallRecipeCell.Props {
        return .init(
            id: recipe.id.rawValue,
            recipeImageSource: recipe.recipeImageSource,
            isLiked: recipe.isFavorite,
            name: recipe.name,
            ratingViewProps: RatingView.Props(ratingText: "\(recipe.rating)")
        )
    }
}
