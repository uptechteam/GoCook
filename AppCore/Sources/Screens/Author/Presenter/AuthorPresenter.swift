//
//  AuthorPresenter.swift
//  
//
//  Created by Oleksii Andriushchenko on 31.05.2023.
//

import Combine

@MainActor
public final class AuthorPresenter {

    // MARK: - Properties

    @Published
    private(set) var state: State

    // MARK: - Lifecycle

    public init(envelope: AuthorEnvelope) {
        self.state = State.makeInitialState(envelope: envelope)
    }

    // MARK: - Public methods

    func backTapped() {
        state.route = .init(value: .didTapBack)
    }
}
