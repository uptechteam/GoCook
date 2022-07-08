//
//  LoginProps.swift
//  
//
//  Created by Oleksii Andriushchenko on 03.07.2022.
//

import Library

extension LoginViewController {
    static func makeProps(from state: State) -> LoginView.Props {
        return .init(
            isLoading: state.isLoggingIn,
            isSkipButtonVisible: false,
            nameInputViewProps: makeNameInputViewProps(state: state),
            passwordInputViewProps: makePasswordInputViewProps(state: state),
            isLoginButtonEnabled: !state.name.isEmpty && !state.password.isEmpty
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
