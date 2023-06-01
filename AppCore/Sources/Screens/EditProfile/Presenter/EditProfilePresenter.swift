//
//  EditProfilePresenter.swift
//  
//
//  Created by Oleksii Andriushchenko on 01.06.2023.
//

import BusinessLogic
import Combine

@MainActor
public final class EditProfilePresenter {

    // MARK: - Properties

    private let profileFacade: ProfileFacading
    @Published
    private(set) var state: State

    // MARK: - Lifecycle

    public init(profileFacade: ProfileFacading) {
        self.profileFacade = profileFacade
        self.state = State.makeInitialState(profile: profileFacade.getProfile())
    }

    // MARK: - Public methods

    func closeTapped() {
        state.route = .init(value: .didTapClose)
    }

    func usernameChanged(_ text: String) {
        state.username = text
    }
}
