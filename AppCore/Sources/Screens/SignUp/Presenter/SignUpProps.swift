//
//  SignUpProps.swift
//  
//
//  Created by Oleksii Andriushchenko on 01.07.2022.
//

import Helpers
import Library

extension SignUpPresenter {
    static func makeProps(from state: State) -> SignUpView.Props {
        return .init(
            isNavigationBarVisible: !state.isRegistration,
            backgroundImageSource: .asset(state.isRegistration ? .registrationBackground : .lowRegistrationBackground),
            isSkipButtonVisible: state.isRegistration,
            title: state.isRegistration ? .signUpTextTitleRegistration : .signUpTextTitleProfile,
            nameInputViewProps: makeNameInputView(state: state),
            passwordInputViewProps: makePasswordInputView(state: state),
            isLoading: state.isSigningUp
        )
    }

    private static func makeNameInputView(state: State) -> RegistrationInputView.Props {
        let isErrorPresent = state.nameErrorMessage != nil
        return .init(
            title: .signUpNameTitle,
            titleColorSource: .color(isErrorPresent ? .errorMain : .textSecondary),
            validationViewProps: makeNameValidationViewProps(state: state),
            dividerColorSource: .color(isErrorPresent ? .errorMain : .appBlack),
            isDescriptionVisible: isErrorPresent,
            description: state.nameErrorMessage ?? "",
            descriptionColorSource: .color(.errorMain)
        )
    }

    private static func makeNameValidationViewProps(state: State) -> InputValidationView.Props {
        if state.isCheckingUsername {
            return .loading
        } else {
            return state.nameErrorMessage == nil ? .valid : .error
        }
    }

    private static func makePasswordInputView(state: State) -> RegistrationInputView.Props {
        return .init(
            title: .signUpPasswordTitle,
            titleColorSource: .color(state.passwordErrorMessage == nil ? .textSecondary : .errorMain),
            validationViewProps: state.passwordErrorMessage == nil ? .empty : .error,
            dividerColorSource: .color(state.passwordErrorMessage == nil ? .appBlack : .errorMain),
            isDescriptionVisible: true,
            description: .signUpPasswordDescription,
            descriptionColorSource: .color(state.passwordErrorMessage == nil ? .textSecondary : .errorMain)
        )
    }
}
