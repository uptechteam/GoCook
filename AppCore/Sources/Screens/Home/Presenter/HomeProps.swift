//
//  HomeProps.swift
//  
//
//  Created by Oleksii Andriushchenko on 13.06.2022.
//

import DomainModels
import Library

extension HomePresenter {
    static func makeProps(from state: State) -> HomeView.Props {
        return .init(
            filtersImage: .asset(state.filters.isEmpty ? .filters : .filterActive),
            feedViewProps: makeFeedViewProps(state: state),
            searchResultsViewProps: makeSearchResultsViewProps(state: state)
        )
    }

    private static func makeFeedViewProps(state: State) -> HomeFeedView.Props {
        return .init(
            isVisible: !state.isSearchActive,
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
        .init(collectionViewProps: makeCategoriesCollectionViewProps(state: state))
    }

    private static func makeCategoriesCollectionViewProps(
        state: State
    ) -> CollectionView<Int, CategoryCell.Props>.Props {
        let allItem = makeCategoryCellProps(title: "All", isSelected: state.selectedCategories.isEmpty)
        let items = CategoryType.priorityOrder.map { type in
            makeCategoryCellProps(title: type.name, isSelected: state.selectedCategories.contains(type))
        }
        return .init(section: [0], items: [[allItem] + items])
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
            headerProps: HomeRecipeCategoryHeaderView.Props(title: recipeCategory.type.name),
            recipesListViewProps: makeRecipesListViewProps(category: recipeCategory)
        )
    }

    private static func makeSearchResultsViewProps(state: State) -> HomeSearchResultsView.Props {
        return .init(
            isVisible: state.isSearchActive,
            filterDescriptionViewProps: makeFilterDescriptionViewProps(state: state),
            isCollectionViewVisible: !state.searchedRecipes.isEmpty,
            items: state.isGettingRecipes ? [] : state.searchedRecipes.map(makeSmallRecipeCellProps),
            contentStateViewProps: makeContentStateViewProps(state: state)
        )
    }

    private static func makeFilterDescriptionViewProps(state: State) -> FiltersDescriptionView.Props {
        return .init(
            isVisible: !state.filters.isEmpty,
            description: makeDescription(state: state)
        )
    }

    private static func makeDescription(state: State) -> String {
        var description: String = .homeFilterDescription
        if !state.filters.categories.isEmpty {
            let categoriesDescription = state.filters.categories
                .map(\.name)
                .joined(separator: .homeCategoriesJoinText)
            description.append(.homeFilterDescriptionCategories(categoriesDescription))
        }

        if !state.filters.timeFilters.isEmpty {
            let timeDescription = state.filters.timeFilters
                .map(makeTimeFilterDescription)
                .joined(separator: .homeTimeFiltersJoinText)
            description.append(.homeFilterDescriptionCookingTime(timeDescription))
        }

        return description
    }

    private static func makeTimeFilterDescription(timeFilter: RecipeTimeFilter) -> String {
        switch timeFilter {
        case .fifteenToThirty:
            return .homeCookingTimeFifteenToThirty

        case .fiveToFifteen:
            return .homeCookingTimeFiveToFifteen

        case .moreThanFortyFive:
            return .homeCookingTimeMoreThanFortyFive

        case .thirtyToFortyFive:
            return .homeCookingTimeThirtyToFortyFive
        }
    }

    private static func makeContentStateViewProps(state: State) -> ContentStateView.Props {
        guard state.isSearchActive else {
            return .hidden
        }

        if state.isGettingRecipes && state.searchedRecipes.isEmpty {
            return .loading
        } else if state.areFilteredRecipesEmpty {
            return .message(title: .homeFilteredEmptyTitle, buttonTitle: .homeFilteredEmptyButton)
        } else if state.searchedRecipes.isEmpty {
            return .message(title: .homeNoResultsTitle, buttonTitle: nil)
        } else {
            return .hidden
        }
    }

    // MARK: - Extra

    private static func makeRecipesListViewProps(category: RecipeCategory) -> HomeRecipesListView.Props {
        .init(items: category.recipes.map(makeRecipeCellProps))
    }

    private static func makeRecipeCellProps(recipe: Recipe) -> RecipeCell.Props {
        return .init(
            id: recipe.id.rawValue,
            recipeImageSource: recipe.recipeImageSource,
            isFavorite: recipe.isFavorite,
            name: recipe.name,
            ratingViewProps: RatingView.makeProps(recipe: recipe)
        )
    }

    private static func makeSmallRecipeCellProps(recipe: Recipe) -> SmallRecipeCell.Props {
        return .init(
            id: recipe.id.rawValue,
            recipeImageSource: recipe.recipeImageSource,
            isFavorite: recipe.isFavorite,
            name: recipe.name,
            ratingViewProps: RatingView.makeProps(recipe: recipe)
        )
    }
}
