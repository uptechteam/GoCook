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

        var isUpdatingProfile: Bool
        let profile: Profile
        var username: String
        var alert: AnyIdentifiable<Alert>?
        var route: AnyIdentifiable<Route>?

        var isDataChanged: Bool {
            username != profile.username
        }

        // MARK: - Public methods

        static func makeInitialState(profile: Profile) -> State {
            return State(
                isUpdatingProfile: false,
                profile: profile,
                username: profile.username,
                alert: nil,
                route: nil
            )
        }
    }

    // MARK: - Route

    enum Alert {
        case error(message: String)
    }

    // MARK: - Route

    enum Route {
        case didTapClose
        case didUpdateProfile
    }
}
