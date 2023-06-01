//
//  EditProfileState.swift
//  
//
//  Created by Oleksii Andriushchenko on 01.06.2023.
//

import Helpers

extension EditProfilePresenter {

    // MARK: - State

    struct State: Equatable {

        // MARK: - Properties

        var route: AnyIdentifiable<Route>?

        // MARK: - Public methods

        static func makeInitialState() -> State {
            return State(
                route: nil
            )
        }
    }

    // MARK: - Route

    enum Route {

    }
}
