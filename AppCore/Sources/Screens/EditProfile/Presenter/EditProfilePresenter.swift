//
//  EditProfilePresenter.swift
//  
//
//  Created by Oleksii Andriushchenko on 01.06.2023.
//

import Combine

@MainActor
public final class EditProfilePresenter {

    // MARK: - Properties

    @Published
    private(set) var state: State

    // MARK: - Lifecycle

    public init() {
        self.state = State.makeInitialState()
    }

    // MARK: - Public methods

    func closeTapped() {
        state.route = .init(value: .didTapClose)
    }
}
