//
//  LoginPresenter.swift
//  
//
//  Created by Oleksii Andriushchenko on 06.06.2023.
//

import BusinessLogic
import Combine
import Foundation
import UIKit

@MainActor
public final class LoginPresenter {

    // MARK: - Properties

    public let keyboardManager: KeyboardManaging
    public let profileFacade: ProfileFacading
    @Published
    private(set) var state: State

    var keyboardHeightChange: any Publisher<CGFloat, Never> {
        return keyboardManager
            .change
            .map { change -> CGFloat in
                switch change.notificationName {
                case UIResponder.keyboardWillHideNotification:
                    return 0

                default:
                    return change.frame.height
                }
            }
            .removeDuplicates()
    }

    // MARK: - Lifecycle

    public init(keyboardManager: KeyboardManaging, profileFacade: ProfileFacading, envelope: LoginEnvelope) {
        self.keyboardManager = keyboardManager
        self.profileFacade = profileFacade
        self.state = State.makeInitialState(envelope: envelope)
    }

    // MARK: - Public methods

    func loginTapped() async {
        state.isLoggingIn = true
        do {
            try await profileFacade.login(username: state.name, password: state.password)
            state.isLoggingIn = false
            state.route = .init(value: .finish)
        } catch {
            state.isLoggingIn = false
            state.alert = .init(value: .error(message: error.localizedDescription))
        }
    }

    func loginWithAppleTapped() {
        state.alert = .init(value: .notImplemented)
    }

    func nameChanged(_ name: String) {
        state.name = name
    }

    func passwordChanged(_ password: String) {
        state.password = password
    }

    func signUpTapped() {
        state.route = .init(value: .signUp)
    }

    func skipTapped() {
        state.route = .init(value: .finish)
    }
}
