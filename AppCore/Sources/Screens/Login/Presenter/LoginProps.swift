//
//  LoginProps.swift
//  
//
//  Created by Oleksii Andriushchenko on 06.06.2023.
//

import Helpers
import Library

extension LoginPresenter {
    static func makeProps(from state: State) -> LoginView.Props {
        return .init(
            isNavigationBarVisible: !state.isRegistration,
            backgroundImageSource: .asset(state.isRegistration ? .registrationBackground : .lowRegistrationBackground),
            isSkipButtonVisible: state.isRegistration,
            title: state.isRegistration ? .loginTextTitleRegistration : .loginTextTitleProfile,
            nameInputViewProps: makeNameInputViewProps(state: state),
            passwordInputViewProps: makePasswordInputViewProps(state: state),
            isLoginButtonEnabled: !state.name.isEmpty && !state.password.isEmpty,
            isLoading: state.isLoggingIn
        )
    }

    private static func makeNameInputViewProps(state: State) -> RegistrationInputView.Props {
        return .init(
            title: .loginNameTitle,
            titleColorSource: .color(.textSecondary),
            validationViewProps: .empty,
            dividerColorSource: .color(.appBlack),
            isDescriptionVisible: false,
            description: "",
            descriptionColorSource: .color(.clear)
        )
    }

    private static func makePasswordInputViewProps(state: State) -> RegistrationInputView.Props {
        return .init(
            title: .loginPasswordTitle,
            titleColorSource: .color(.textSecondary),
            validationViewProps: .empty,
            dividerColorSource: .color(.appBlack),
            isDescriptionVisible: false,
            description: "",
            descriptionColorSource: .color(.clear)
        )
    }
}
