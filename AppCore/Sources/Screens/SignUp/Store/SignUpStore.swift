//
//  SignUpStore.swift
//  
//
//  Created by Oleksii Andriushchenko on 01.07.2022.
//

import Helpers

extension SignUpViewController {

    public typealias Store = ReduxStore<State, Action>

    public struct State: Equatable {
        var name: String
        var password: String
        var route: AnyIdentifiable<Route>?
    }

    public enum Action {
        case loginTapped
        case nameChanged(String)
        case passwordChanged(String)
        case signUpTapped
        case signUpWithAppleTapped
        case skipTapped
    }

    enum Route {
        case finish
        case login
    }

    public struct Dependencies {
        public init() {

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
            name: "",
            password: "",
            route: nil
        )
    }
}

extension SignUpViewController {
    static func reduce(state: State, action: Action) -> State {

        var newState = state

        switch action {
        case .loginTapped:
            newState.route = .init(value: .login)

        case .nameChanged(let text):
            newState.name = text

        case .passwordChanged(let text):
            newState.password = text

        case .signUpTapped:
            break

        case .signUpWithAppleTapped:
            break

        case .skipTapped:
            newState.route = .init(value: .finish)
        }

        return newState
    }
}

