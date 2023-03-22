//
//  FiltersProps.swift
//  
//
//  Created by Oleksii Andriushchenko on 21.03.2023.
//

import DomainModels
import Helpers

extension FiltersPresenter {

    static func makeIsRightBarButtonHidden(from state: State) -> Bool {
        state.selectedCategories.isEmpty && state.selectedTimeFilters.isEmpty
    }

    static func makeProps(from state: State) -> FiltersView.Props {
        return .init(
            categorySectionViewProps: makeCategorySectionViewProps(state: state),
            cookingTimeSectionViewProps: makeCookingTimeSectionViewProps(state: state)
        )
    }

    private static func makeCategorySectionViewProps(state: State) -> FiltersSectionView.Props {
        return .init(
            title: .filtersSectionCategory,
            optionViewsProps: state.allCategories.map { category in
                return makeOptionViewProps(
                    title: category.name,
                    isSelected: state.selectedCategories.contains(category)
                )
            }
        )
    }

    private static func makeCookingTimeSectionViewProps(state: State) -> FiltersSectionView.Props {
        return .init(
            title: .filtersSectionCookingTime,
            optionViewsProps: state.allTimeFilters.map { timeFilter in
                return makeOptionViewProps(
                    title: makeTimeFilterTitle(timeFilter: timeFilter),
                    isSelected: state.selectedTimeFilters.contains(timeFilter)
                )
            }
        )
    }

    private static func makeTimeFilterTitle(timeFilter: RecipeTimeFilter) -> String {
        switch timeFilter {
        case .fifteenToThirty:
            return .filtersSectionCookingTimeFifteenToThirty

        case .fiveToFifteen:
            return .filtersSectionCookingTimeFiveToFifteen

        case .moreThanFortyFive:
            return .filtersSectionCookingTimeMoreThanFortyFive

        case .thirtyToFortyFive:
            return .filtersSectionCookingTimeThirtyToFortyFive
        }
    }

    // MARK: - Extra

    private static func makeOptionViewProps(title: String, isSelected: Bool) -> FiltersOptionView.Props {
        return .init(
            title: title,
            checmarkImage: .asset(isSelected ? .filledCheckbox : .emptyCheckbox)
        )
    }
}
