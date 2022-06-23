//
//  ProfileStore.swift
//  
//
//  Created by Oleksii Andriushchenko on 15.06.2022.
//

import BusinessLogic
import DomainModels
import Helpers

extension ProfileViewController {

    public typealias Store = ReduxStore<State, Action>

    public struct State: Equatable {
        var profile: Profile?
    }

    public enum Action {
        case login
        case updateProfile(Profile?)
    }

    enum Route {

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
        return Store(
            initialState: makeInitialState(dependencies: dependencies),
            reducer: reduce,
            middlewares: []
        )
    }

    private static func makeInitialState(dependencies: Dependencies) -> State {
        return State(
            profile: nil
        )
    }
}

extension ProfileViewController {
    static func reduce(state: State, action: Action) -> State {

        var newState = state

        switch action {
        case .login:
            break

        case .updateProfile(let profile):
            newState.profile = profile
        }

        return newState
    }
}
