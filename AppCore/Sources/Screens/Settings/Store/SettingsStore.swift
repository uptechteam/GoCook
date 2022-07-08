//
//  SettingsStore.swift
//  
//
//  Created by Oleksii Andriushchenko on 08.07.2022.
//

import BusinessLogic
import Helpers

extension SettingsViewController {

    public typealias Store = ReduxStore<State, Action>

    public struct State: Equatable {
        var isLoggingOut: Bool
        var route: AnyIdentifiable<Route>?
    }

    public enum Action {
        case logoutSuccess
        case logoutTapped
    }

    enum Route {
        case logout
    }

    public struct Dependencies {

        // MARK: - Properties

        public let profileFacade: ProfileFacading

        // MARK: - Lifecycle

        public init(profileFacade: ProfileFacading) {
            self.profileFacade = profileFacade
        }
    }

    public static func makeStore(dependencies: Dependencies) -> Store {
        let logoutMiddleware = makeLogoutMiddleware(dependencies: dependencies)
        return Store(
            initialState: makeInitialState(dependencies: dependencies),
            reducer: reduce,
            middlewares: [logoutMiddleware]
        )
    }

    private static func makeInitialState(dependencies: Dependencies) -> State {
        return State(
            isLoggingOut: false,
            route: nil
        )
    }
}

extension SettingsViewController {
    static func reduce(state: State, action: Action) -> State {

        var newState = state

        switch action {
        case .logoutSuccess:
            newState.isLoggingOut = false
            newState.route = .init(value: .logout)

        case .logoutTapped:
            newState.isLoggingOut = true
        }

        return newState
    }
}
