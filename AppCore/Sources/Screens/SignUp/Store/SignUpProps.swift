//
//  SignUpProps.swift
//  
//
//  Created by Oleksii Andriushchenko on 01.07.2022.
//

import Library

extension SignUpViewController {
    static func makeProps(from state: State) -> SignUpView.Props {
        return .init(
            nameInputViewProps: makeNameInputView(state: state),
            passwordInputViewProps: makePasswordInputView(state: state)
        )
    }

    private static func makeNameInputView(state: State) -> UserInputView.Props {
        return .init(
            title: .signUpNameTitle,
            titleColorSource: .color(.textSecondary),
            dividerColorSource: .color(.appBlack),
            errorMessage: "",
            isErrorMessageVisible: false
        )
    }

    private static func makePasswordInputView(state: State) -> UserInputView.Props {
        return .init(
            title: .signUpPasswordTitle,
            titleColorSource: .color(.textSecondary),
            dividerColorSource: .color(.appBlack),
            errorMessage: "",
            isErrorMessageVisible: false
        )
    }
}
