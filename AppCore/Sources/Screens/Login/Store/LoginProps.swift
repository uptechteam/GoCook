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
            nameInputViewProps: makeNameInputViewProps(state: state),
            passwordInputViewProps: makePasswordInputViewProps(state: state)
        )
    }

    private static func makeNameInputViewProps(state: State) -> UserInputView.Props {
        return .init(
            title: .loginNameTitle, titleColorSource: .color(.textSecondary),
            dividerColorSource: .color(.appBlack),
            errorMessage: "",
            isErrorMessageVisible: false
        )
    }

    private static func makePasswordInputViewProps(state: State) -> UserInputView.Props {
        return .init(
            title: .loginPasswordTitle,
            titleColorSource: .color(.textSecondary),
            dividerColorSource: .color(.appBlack),
            errorMessage: "",
            isErrorMessageVisible: false
        )
    }
}
