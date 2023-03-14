//
//  FiltersPresenter.swift
//  
//
//  Created by Oleksii Andriushchenko on 14.03.2023.
//

import Combine

@MainActor
public final class FiltersPresenter {

    struct State: Equatable {

    }

    // MARK: - Properties

    @Published
    private(set) var state: State

    // MARK: - Lifecycle

    public init() {
        self.state = State()
    }

    // MARK: - Public methods

    // TBD
}
