//
//  EditProfileProps.swift
//  
//
//  Created by Oleksii Andriushchenko on 01.06.2023.
//

import Helpers
import Library

extension EditProfilePresenter {
    static func makeProps(from state: State) -> EditProfileView.Props {
        return .init(
            avatarViewProps: makeAvatarViewProps(state: state),
            usernameInputViewProps: makeUsernameInputViewProps(state: state),
            isSubmitButtonEnabled: state.isDataChanged,
            isSpinnerVisible: state.isUpdatingProfile
        )
    }

    private static func makeAvatarViewProps(state: State) -> EditProfileAvatarView.Props {
        return .init(
            isSpinnerVisible: false,
            avatar: state.avatar
        )
    }

    private static func makeUsernameInputViewProps(state: State) -> UserInputView.Props {
        return .init(
            text: state.username,
            errorMessage: nil
        )
    }
}
