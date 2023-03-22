//
//  FiltersPresenter.swift
//  
//
//  Created by Oleksii Andriushchenko on 21.03.2023.
//

import BusinessLogic
import Combine

@MainActor
public final class FiltersPresenter {

    // MARK: - Properties

    private let filtersFacade: FiltersFacading
    @Published
    private(set) var state: State

    // MARK: - Lifecycle

    public init(filtersFacade: FiltersFacading) {
        self.filtersFacade = filtersFacade
        self.state = State.makeInitialState()
        Task {
            await observeFilters()
        }
    }

    // MARK: - Public methods

    func applyTapped() async {
        let filter = state.makeFilters()
        await filtersFacade.update(filters: filter)
        state.route = .init(value: .didApplyFilters)
    }

    func categoryTapped(index: Int) {
        guard let category = state.allCategories[safe: index] else {
            return
        }

        if state.selectedCategories.contains(category) {
            state.selectedCategories.remove(category)
        } else {
            state.selectedCategories.insert(category)
        }
    }

    func clearTapped() {
        state.selectedCategories = Set()
        state.selectedTimeFilters = Set()
    }

    func cookingTimeTapped(index: Int) {
        guard let timeFilter = state.allTimeFilters[safe: index] else {
            return
        }

        if state.selectedTimeFilters.contains(timeFilter) {
            state.selectedTimeFilters.remove(timeFilter)
        } else {
            state.selectedTimeFilters.insert(timeFilter)
        }
    }

    // MARK: - Private methods

    private func observeFilters() async {
        for await filter in await filtersFacade.observeFilters().values {
            state.adjustState(accordingTo: filter)
        }
    }
}
