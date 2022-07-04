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
            isLoading: state.isSigningUp,
            nameInputViewProps: makeNameInputView(state: state),
            passwordInputViewProps: makePasswordInputView(state: state)
        )
    }

    private static func makeNameInputView(state: State) -> RegistrationInputView.Props {
        let isErrorPresent = state.nameValidation.error != nil
        return .init(
            title: .signUpNameTitle,
            titleColorSource: .color(isErrorPresent ? .errorMain : .textSecondary),
            validationViewProps: makeNameValidationViewProps(state: state),
            dividerColorSource: .color(isErrorPresent ? .errorMain : .appBlack),
            isDescriptionVisible: isErrorPresent,
            description: state.nameValidation.error?.localizedDescription ?? "",
            descriptionColorSource: .color(.errorMain)
        )
    }

    private static func makeNameValidationViewProps(state: State) -> InputValidationView.Props {
        guard state.nameValidation.isPresent else {
            return .empty
        }

        if state.nameValidation.isLoading {
            return .loading
        } else {
            return state.nameValidation.value && state.nameValidation.error == nil ? .valid : .error
        }
    }

    private static func makePasswordInputView(state: State) -> RegistrationInputView.Props {
        return .init(
            title: .signUpPasswordTitle,
            titleColorSource: .color(state.isPasswordValid ? .textSecondary : .errorMain),
            validationViewProps: state.isPasswordValid ? .empty : .error,
            dividerColorSource: .color(state.isPasswordValid ? .appBlack : .errorMain),
            isDescriptionVisible: true,
            description: .signUpPasswordDescription,
            descriptionColorSource: .color(state.isPasswordValid ? .textSecondary : .errorMain)
        )
    }
}
