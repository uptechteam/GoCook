//
//  LoginState.swift
//  
//
//  Created by Oleksii Andriushchenko on 06.06.2023.
//

import DomainModels
import Helpers

extension LoginPresenter {

    // MARK: - State

    struct State: Equatable {

        // MARK: - Properties

        var envelope: LoginEnvelope
        var isLoggingIn: Bool
        var name: String
        var password: String
        var alert: AnyIdentifiable<Alert>?
        var route: AnyIdentifiable<Route>?

        var isRegistration: Bool {
            envelope == .registration
        }

        // MARK: - Public methods

        static func makeInitialState(envelope: LoginEnvelope) -> State {
            return State(
                envelope: envelope,
                isLoggingIn: false,
                name: "",
                password: "",
                alert: nil,
                route: nil
            )
        }
    }

    // MARK: - Alert

    enum Alert {
        case notImplemented
        case error(message: String)
    }

    // MARK: - Route

    enum Route {
        case didFinish
        case didTapSignUp
    }
}
