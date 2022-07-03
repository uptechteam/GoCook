//
//  SignUpStore.swift
//  
//
//  Created by Oleksii Andriushchenko on 01.07.2022.
//

import BusinessLogic
import Helpers

extension SignUpViewController {

    public typealias Store = ReduxStore<State, Action>

    public struct State: Equatable {
        var name: String
        var password: String
        var alert: AnyIdentifiable<Alert>?
        var route: AnyIdentifiable<Route>?
    }

    public enum Action {
        case loginTapped
        case nameChanged(String)
        case passwordChanged(String)
        case signUp(DomainModelAction<Void>)
        case signUpTapped
        case signUpWithAppleTapped
        case skipTapped
    }

    enum Alert {
        case error(Error)
    }

    enum Route {
        case finish
        case login
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
        let signUpMiddleware = makeSignUpMiddleware(dependencies: dependencies)
        return Store(
            initialState: makeInitialState(dependencies: dependencies),
            reducer: reduce,
            middlewares: [signUpMiddleware]
        )
    }

    private static func makeInitialState(dependencies: Dependencies) -> State {
        return State(
            name: "",
            password: "",
            alert: nil,
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

        case .signUp(let modelAction):
            switch modelAction {
            case .failure(let error):
                newState.alert = .init(value: .error(error))

            case .success:
                newState.route = .init(value: .finish)

            default:
                break
            }

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
