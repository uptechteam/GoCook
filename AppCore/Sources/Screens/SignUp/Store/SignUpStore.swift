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
        var isPasswordValid: Bool
        var isSigningUp: Bool
        var name: String
        var nameValidation: DomainModelState<Bool>
        var password: String
        var alert: AnyIdentifiable<Alert>?
        var route: AnyIdentifiable<Route>?
    }

    public enum Action {
        case loginTapped
        case nameChanged(String)
        case nameValidated(DomainModelAction<Bool>)
        case passwordChanged(String)
        case passwordValidated(Bool)
        case signUp(DomainModelAction<Void>)
        case signUpTapped
        case signUpWithAppleTapped
        case skipTapped
    }

    enum Alert {
        case notImplemented
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
        let validatePassword = makeValidatePasswordMiddleware(dependencies: dependencies)
        let validateUsernameMiddleware = makeValidateUsernameMiddleware(dependencies: dependencies)
        return Store(
            initialState: makeInitialState(dependencies: dependencies),
            reducer: reduce,
            middlewares: [signUpMiddleware, validatePassword, validateUsernameMiddleware]
        )
    }

    private static func makeInitialState(dependencies: Dependencies) -> State {
        return State(
            isPasswordValid: true,
            isSigningUp: false,
            name: "",
            nameValidation: DomainModelState(),
            password: "",
            alert: nil,
            route: nil
        )
    }
}

extension SignUpViewController {
    // swiftlint:disable:next cyclomatic_complexity
    static func reduce(state: State, action: Action) -> State {

        var newState = state

        switch action {
        case .loginTapped:
            newState.route = .init(value: .login)

        case .nameChanged(let text):
            newState.name = text
            if text.isEmpty {
                newState.nameValidation = DomainModelState()
            } else {
                newState.nameValidation.toggleIsLoading(on: true)
            }

        case .nameValidated(let modelAction):
            newState.nameValidation.handle(action: modelAction)

        case .passwordChanged(let text):
            newState.isPasswordValid = true
            newState.password = text

        case .passwordValidated(let isValid):
            newState.isPasswordValid = isValid
            if isValid {
                newState.isSigningUp = true
            }

        case .signUp(let modelAction):
            newState.isSigningUp = false
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
            newState.alert = .init(value: .notImplemented)

        case .skipTapped:
            newState.route = .init(value: .finish)
        }

        return newState
    }
}
