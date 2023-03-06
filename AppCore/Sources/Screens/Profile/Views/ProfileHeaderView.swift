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
        setupAvatarImageView()
        setupSignInButton()
        setupNameLabel()
        setupStackView()
    }

    private func setupBackgroundImageView() {
        backgroundImageView.image = .profileBackground
        backgroundImageView.contentMode = .scaleAspectFill
        addSubview(backgroundImageView, constraints: [
            backgroundImageView.topAnchor.constraint(equalTo: topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func setupEditButton() {
        editButton.set(image: .editFilled)
        editButton.addAction(UIAction(handler: { [weak self] _ in self?.onTapSettings() }), for: .touchUpInside)
        addSubview(editButton, constraints: [
            editButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 14),
            editButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 23.5)
        ])
    }

    private func setupSettingsButton() {
        settingsButton.set(image: .settings)
        settingsButton.addAction(UIAction(handler: { [weak self] _ in self?.onTapSettings() }), for: .touchUpInside)
        addSubview(settingsButton, constraints: [
            settingsButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 12),
            settingsButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -22)
        ])
    }

    private func setupAvatarImageView() {
        avatarImageView.layer.roundCornersContinuosly(radius: 48)
        avatarImageView.clipsToBounds = true
        NSLayoutConstraint.activate([
            avatarImageView.widthAnchor.constraint(equalToConstant: 96),
            avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor)
        ])
    }

    private func setupSignInButton() {
        signInButton.setTitle(.profileSignIn)
        signInButton.addAction(UIAction(handler: { [weak self] _ in self?.onTapSignIn() }), for: .touchUpInside)
    }

    private func setupNameLabel() {
        nameLabel.isHidden = true
        nameLabel.render(typography: .headerTwo)
        nameLabel.textColor = .appWhite
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

    // MARK: - Public methods

    func render(props: Props) {
        editButton.isHidden = !props.isEditButtonVisible
        settingsButton.isHidden = !props.isSettingsButtonVisible
        avatarImageView.set(props.avatarImageSource, placeholder: .avatarPlaceholder)
        signInButton.isHidden = !props.isSignInButtonVisible
        nameLabel.isHidden = !props.isNameLabelVisible
        nameLabel.text = props.name
    }
}
