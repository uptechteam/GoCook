//
//  FavoritesPresenter.swift
//  
//
//  Created by Oleksii Andriushchenko on 13.03.2023.
//

import Combine

public actor FavoritesPresenter {

    struct State: Equatable {

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
    @Published private(set) var state: State = State()

    // MARK: - Lifecycle

    public init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    // MARK: - Public methods
}
