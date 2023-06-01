//
//  EditProfileState.swift
//  
//
//  Created by Oleksii Andriushchenko on 01.06.2023.
//

import DomainModels
import Helpers

extension EditProfilePresenter {

    // MARK: - State

    struct State: Equatable {

        // MARK: - Properties

        let profile: Profile
        var username: String
        var route: AnyIdentifiable<Route>?

        var isDataChanged: Bool {
            username != profile.username
        }

        // MARK: - Public methods

        static func makeInitialState(profile: Profile) -> State {
            return State(
                profile: profile,
                username: profile.username,
                route: nil
            )
        }
    }

    // MARK: - Route

    enum Route {
        case didTapClose
    }
}
