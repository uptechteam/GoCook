//
//  FavoritesPresenter.swift
//  
//
//  Created by Oleksii Andriushchenko on 13.03.2023.
//

import Combine
import DomainModels
import Helpers

public actor FavoritesPresenter {

    struct State: Equatable {
        var query: String
        var recipes: DomainModelState<[Recipe]>
        var route: AnyIdentifiable<Route>?
    }

    enum Route {
        case didTapFilter
    }

    public struct Dependencies {

        // MARK: - Properties

        // MARK: - Lifecycle

        public init() {

        }
    }

    // MARK: - Properties

    // Dependencies
    private let dependencies: Dependencies
    // Variables
    @Published private(set) var state: State

    // MARK: - Lifecycle

    public init(dependencies: Dependencies) {
        self.dependencies = dependencies
        self.state = State(query: "", recipes: DomainModelState(), route: nil)
    }

    // MARK: - Public methods

    func filterTapped() {
        state.route = .init(value: .didTapFilter)
    }

    func searchQueryChanged(_ query: String) {
        state.query = query
    }
}
