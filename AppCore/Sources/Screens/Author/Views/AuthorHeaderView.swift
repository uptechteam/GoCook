//
//  AuthorHeaderView.swift
//  
//
//  Created by Oleksii Andriushchenko on 31.05.2023.
//

import Helpers
import Library
import UIKit

final class AuthorHeaderView: UIView {

    struct Props: Equatable {
        let avatarImageSource: ImageSource
        let name: String
    }

    // MARK: - Properties

    private let backgroundImageView = UIImageView()
    private let backButton = IconButton()
    private let avatarImageView = UIImageView()
    private let nameLabel = UILabel()
    // callbacks
    var onTapBack: () -> Void = { }

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
        setupBackButton()
        setupStackView()
        setupAvatarImageView()
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

    private func setupBackButton() {
        backButton.addAction(UIAction(handler: { [unowned self] _ in onTapBack() }), for: .touchUpInside)
        backButton.set(image: .circleBackButton)
        addSubview(backButton, constraints: [
            backButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 2),
            backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12)
        ])
    }

    private func setupStackView() {
        let stackView = UIStackView(arrangedSubviews: [avatarImageView, nameLabel])
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

    // MARK: - Public methods

    func render(props: Props) {
        avatarImageView.set(props.avatarImageSource, placeholder: .avatarPlaceholder)
        nameLabel.render(title: props.name, color: .appWhite, typography: .headerTwo)
    }
}
