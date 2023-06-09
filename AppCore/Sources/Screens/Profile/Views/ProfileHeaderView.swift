//
//  ProfileHeaderView.swift
//  
//
//  Created by Oleksii Andriushchenko on 21.06.2022.
//

import Helpers
import Library
import UIKit

final class ProfileHeaderView: UIView {

    struct Props: Equatable {
        let isEditButtonVisible: Bool
        let isSettingsButtonVisible: Bool
        let avatarImageSource: ImageSource
        let isSignInButtonVisible: Bool
        let isNameLabelVisible: Bool
        let name: String
    }

    // MARK: - Properties

    private let backgroundImageView = UIImageView()
    private let editButton = IconButton()
    private let settingsButton = IconButton()
    private let avatarImageView = UIImageView()
    private let signInButton = Button(config: ButtonConfig(buttonSize: .medium, colorConfig: .error))
    private let nameLabel = UILabel()
    // callbacks
    var onTapEdit: () -> Void = { }
    var onTapSettings: () -> Void = { }
    var onTapSignIn: () -> Void = { }

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
        setupBackgroundImageView()
        setupEditButton()
        setupSettingsButton()
        setupStackView()
        setupAvatarImageView()
        setupSignInButton()
        setupNameLabel()
    }

    private func setupBackgroundImageView() {
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.image = .profileBackground
        addSubview(backgroundImageView, constraints: [
            backgroundImageView.topAnchor.constraint(equalTo: topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func setupEditButton() {
        editButton.addAction(UIAction(handler: { [unowned self] _ in onTapEdit() }), for: .touchUpInside)
        editButton.set(image: .editFilled)
        addSubview(editButton, constraints: [
            editButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 14),
            editButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 23.5)
        ])
    }

    private func setupSettingsButton() {
        settingsButton.addAction(UIAction(handler: { [unowned self] _ in onTapSettings() }), for: .touchUpInside)
        settingsButton.set(image: .settings)
        addSubview(settingsButton, constraints: [
            settingsButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 12),
            settingsButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -22)
        ])
    }

    private func setupStackView() {
        let stackView = UIStackView(arrangedSubviews: [avatarImageView, signInButton, nameLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.setCustomSpacing(16, after: avatarImageView)
        addSubview(
            stackView,
            withEdgeInsets: UIEdgeInsets(top: 56, left: 0, bottom: 32, right: 0),
            isSafeAreaRequired: true
        )
    }

    private func setupAvatarImageView() {
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.roundCornersContinuosly(radius: 48)
        NSLayoutConstraint.activate([
            avatarImageView.widthAnchor.constraint(equalToConstant: 96),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor)
        ])
    }

    private func setupSignInButton() {
        signInButton.addAction(UIAction(handler: { [unowned self] _ in onTapSignIn() }), for: .touchUpInside)
        signInButton.setTitle(.profileSignIn)
    }

    private func setupNameLabel() {
        nameLabel.isHidden = true
    }

    // MARK: - Public methods

    func render(props: Props) {
        editButton.isHidden = !props.isEditButtonVisible
        settingsButton.isHidden = !props.isSettingsButtonVisible
        avatarImageView.set(props.avatarImageSource, placeholder: .avatarPlaceholder)
        signInButton.isHidden = !props.isSignInButtonVisible
        nameLabel.isHidden = !props.isNameLabelVisible
        nameLabel.render(title: props.name, color: .appWhite, typography: .headerTwo)
    }
}
