//
//  SignUpPresenter.swift
//  
//
//  Created by Oleksii Andriushchenko on 06.06.2023.
//

import BusinessLogic
import Combine
import DomainModels
import Foundation
import Helpers
import UIKit

@MainActor
public final class SignUpPresenter {

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

    public init(keyboardManager: KeyboardManaging, profileFacade: ProfileFacading, envelope: SignUpEnvelope) {
        self.keyboardManager = keyboardManager
        self.profileFacade = profileFacade
        self.state = State.makeInitialState(envelope: envelope)
    }

    // MARK: - Public methods

    func loginTapped() {
        state.route = .init(value: .login)
    }

    func nameChanged(_ name: String) {
        state.name = name
        state.nameErrorMessage = nil
    }

    func passwordChagned(_ password: String) {
        state.password = password
        state.passwordErrorMessage = nil
    }

    func signUpTapped() async {
        await validateCredentials()
        guard state.areCredentialsValid else {
            return
        }

        do {
            try await profileFacade.signUp(username: state.name, password: state.password)
            state.route = .init(value: .finish)
        } catch {
            state.alert = .init(value: .error(error))
        }
    }

    func signUpWithAppleTapped() {
        state.alert = .init(value: .notImplemented)
    }

    func skipTapped() {
        state.route = .init(value: .finish)
    }

    // MARK: - Private methods

    private func validateCredentials() async {
        guard AppConstants.Validation.nameLengthRange ~= state.name.count else {
            state.nameErrorMessage = ValidationError.nameLength.errorDescription
            return
        }

        do {
            state.isCheckingUsername = true
            let isUnique = try await profileFacade.isUnique(username: state.name)
            state.isCheckingUsername = false
            guard isUnique else {
                state.nameErrorMessage = ValidationError.notUniqueUsername.errorDescription
                return
            }
        } catch {
            state.isCheckingUsername = false
            state.nameErrorMessage = error.localizedDescription
            return
        }

        let password = state.password
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\d]{8,50}$"
        let isPasswordValid = NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
        if !isPasswordValid {
            state.passwordErrorMessage = .signUpPasswordDescription
        }
    }
}
