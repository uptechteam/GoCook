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
        var route: AnyIdentifiable<Route>?
    }

    public enum Action {
        case addNewRecipeTapped
        case settingsTapped
        case signInTapped
        case updateProfile(Profile?)
    }

    enum Route {
        case createRecipe
        case settings
        case signIn
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
            profile: nil,
            route: nil
        )
    }
}

extension ProfileViewController {
    static func reduce(state: State, action: Action) -> State {

        var newState = state

        switch action {
        case .addNewRecipeTapped:
            newState.route = .init(value: .createRecipe)

        case .settingsTapped:
            newState.route = .init(value: .settings)

        case .signInTapped:
            newState.route = .init(value: .signIn)

        case .updateProfile(let profile):
            newState.profile = profile
        }

        return newState
    }
}
