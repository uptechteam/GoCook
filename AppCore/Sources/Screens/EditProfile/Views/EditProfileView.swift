//
//  EditProfileView.swift
//  
//
//  Created by Oleksii Andriushchenko on 01.06.2023.
//

import Library
import UIKit

final class EditProfileView: UIView {

    struct Props: Equatable {
        let avatarViewProps: EditProfileAvatarView.Props
        let usernameInputViewProps: UserInputView.Props
        let isSubmitButtonEnabled: Bool
    }

    // MARK: - Properties

    private let dividerView = UIView()
    let avatarView = EditProfileAvatarView()
    let usernameInputView = UserInputView()
    let submitButton = Button(config: ButtonConfig(colorConfig: .primary))

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Set up

    private func setup() {
        setupContentView()
        setupDividerView()
        setupStackView()
        setupUsernameInputView()
        setupSubmitButton()
    }

    private func setupContentView() {
        backgroundColor = .appWhite
    }

    private func setupDividerView() {
        dividerView.backgroundColor = .divider
        addSubview(dividerView, constraints: [
            dividerView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            dividerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dividerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            dividerView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }

    private func setupStackView() {
        let centeredAvatarView = avatarView.centeredHorizontally()
        let stackView = UIStackView(
            arrangedSubviews: [centeredAvatarView, usernameInputView, UIView(), submitButton]
        )
        stackView.axis = .vertical
        stackView.setCustomSpacing(24, after: centeredAvatarView)
        addSubview(
            stackView,
            withEdgeInsets: UIEdgeInsets(top: 24, left: 24, bottom: 0, right: 24),
            isSafeAreaRequired: true
        )
    }

    private func setupUsernameInputView() {
        usernameInputView.configure(title: .editProfileInputTitle)
    }

    private func setupSubmitButton() {
        submitButton.setTitle(.editProfileSubmit)
    }

    // MARK: - Public methods

    func render(props: Props) {
        avatarView.render(props: props.avatarViewProps)
        usernameInputView.render(props: props.usernameInputViewProps)
        submitButton.isEnabled = props.isSubmitButtonEnabled
    }
}
