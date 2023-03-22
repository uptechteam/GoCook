//
//  FiltersFacade.swift
//  
//
//  Created by Oleksii Andriushchenko on 22.03.2023.
//

import Combine
import DomainModels

public protocol FiltersFacading: Sendable {
    func observeFilters() async -> AnyPublisher<RecipeFilters, Never>
    func update(filters: RecipeFilters) async
}

public actor FiltersFacade: FiltersFacading {

    // MARK: - Properties

    private var filters: RecipeFilters
    private let filtersSubject: CurrentValueSubject<RecipeFilters, Never>

    // MARK: - Lifecycle

    public init() {
        self.filters = RecipeFilters(categories: [], timeFilters: [])
        self.filtersSubject = CurrentValueSubject(RecipeFilters(categories: [], timeFilters: []))
    }

    // MARK: - Public methods

    public func observeFilters() -> AnyPublisher<RecipeFilters, Never> {
        filtersSubject.eraseToAnyPublisher()
    }

    public func update(filters: RecipeFilters) {
        self.filters = filters
        self.filtersSubject.send(filters)
    }
}
