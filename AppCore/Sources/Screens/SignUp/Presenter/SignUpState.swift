//
//  SignUpState.swift
//  
//
//  Created by Oleksii Andriushchenko on 06.06.2023.
//

import DomainModels
import Helpers

extension SignUpPresenter {

    // MARK: - State

    struct State: Equatable {

        // MARK: - Properties

        var envelope: SignUpEnvelope
        var isCheckingUsername: Bool
        var isSigningUp: Bool
        var name: String
        var nameErrorMessage: String?
        var password: String
        var passwordErrorMessage: String?
        var alert: AnyIdentifiable<Alert>?
        var route: AnyIdentifiable<Route>?

        var areCredentialsValid: Bool {
            nameErrorMessage == nil && passwordErrorMessage == nil
        }

        var isRegistration: Bool {
            envelope == .registration
        }

        // MARK: - Public methods

        static func makeInitialState(envelope: SignUpEnvelope) -> State {
            return State(
                envelope: envelope,
                isCheckingUsername: false,
                isSigningUp: false,
                name: "",
                nameErrorMessage: nil,
                password: "",
                passwordErrorMessage: nil,
                alert: nil,
                route: nil
            )
        }
    }

    // MARK: - Alert

    enum Alert {
        case notImplemented
        case error(Error)
    }

    // MARK: - Route

    enum Route {
        case didFinish
        case didTapLogin
    }
}
