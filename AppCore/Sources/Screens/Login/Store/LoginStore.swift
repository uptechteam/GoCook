//
//  LoginStore.swift
//  
//
//  Created by Oleksii Andriushchenko on 03.07.2022.
//

import BusinessLogic
import Helpers

extension LoginViewController {

    public typealias Store = ReduxStore<State, Action>

    public struct State: Equatable {
        var isLoggingIn: Bool
        var name: String
        var password: String
        var alert: AnyIdentifiable<Alert>?
        var route: AnyIdentifiable<Route>?
    }

    public enum Action {
        case login(DomainModelAction<Void>)
        case loginTapped
        case loginWithAppleTapped
        case nameChanged(String)
        case passwordChanged(String)
        case signUp
        case skipTapped
    }

    enum Alert {
        case notImplemented
        case error(Error)
    }

    enum Route {
        case finish
        case signUp
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
        let loginMiddleware = makeLoginMiddleware(dependencies: dependencies)
        return Store(
            initialState: makeInitialState(dependencies: dependencies),
            reducer: reduce,
            middlewares: [loginMiddleware]
        )
    }

    private static func makeInitialState(dependencies: Dependencies) -> State {
        return State(
            isLoggingIn: false,
            name: "",
            password: "",
            alert: nil,
            route: nil
        )
    }
}

extension LoginViewController {
    static func reduce(state: State, action: Action) -> State {

        var newState = state

        switch action {
        case .login(let modelAction):
            newState.isLoggingIn = false
            switch modelAction {
            case .failure(let error):
                newState.alert = .init(value: .error(error))

            case .success:
                newState.route = .init(value: .finish)

            default:
                break
            }

        case .loginTapped:
            newState.isLoggingIn = true

        case .loginWithAppleTapped:
            newState.alert = .init(value: .notImplemented)

        case .nameChanged(let text):
            newState.name = text

        case .passwordChanged(let text):
            newState.password = text

        case .signUp:
            newState.route = .init(value: .signUp)

        case .skipTapped:
            newState.route = .init(value: .finish)
        }

        return newState
    }
}
