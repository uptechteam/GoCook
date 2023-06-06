//
//  SettingsState.swift
//  
//
//  Created by Oleksii Andriushchenko on 06.06.2023.
//

import Helpers

extension SettingsPresenter {

    // MARK: - State

    struct State: Equatable {

        // MARK: - Properties

        var isLoggingOut: Bool
        var route: AnyIdentifiable<Route>?

        // MARK: - Public methods

        static func makeInitialState() -> State {
            return State(
                isLoggingOut: false,
                route: nil
            )
        }
    }

    // MARK: - Route

    enum Route {
        case logout
    }
}
