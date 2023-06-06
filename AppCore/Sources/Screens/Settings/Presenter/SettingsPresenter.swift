//
//  SettingsPresenter.swift
//  
//
//  Created by Oleksii Andriushchenko on 06.06.2023.
//

import BusinessLogic
import Combine

@MainActor
public final class SettingsPresenter {

    // MARK: - Properties

    public let profileFacade: ProfileFacading
    @Published
    private(set) var state: State

    // MARK: - Lifecycle

    public init(profileFacade: ProfileFacading) {
        self.profileFacade = profileFacade
        self.state = State.makeInitialState()
    }

    // MARK: - Public methods

    func logoutTapped() async {
        guard !state.isLoggingOut else {
            return
        }

        state.isLoggingOut = true
        await profileFacade.logout()
        state.isLoggingOut = false
        state.route = .init(value: .logout)
    }
}
